import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:uuid/uuid.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/widgets/button.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/utils/loading.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/lobby/show_register_fail_dialog.dart';

import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/utils/fetcher.dart';

final logger = Logger();

class GameRegisterIdCardBinding extends StatefulWidget {
  const GameRegisterIdCardBinding({super.key});

  @override
  GameRegisterIdCardBindingState createState() =>
      GameRegisterIdCardBindingState();
}

class GameRegisterIdCardBindingState extends State<GameRegisterIdCardBinding> {
  SystemConfigController systemController = Get.find<SystemConfigController>();

  String? frontImagePath;
  String? backImagePath;
  String? frontImageSid;
  String? backImageSid;
  bool isFrontLoading = false;
  bool isBackLoading = false;

  void setLoading(bool value, String type) {
    if (type == 'front') {
      setState(() {
        isFrontLoading = value;
      });
    } else if (type == 'back') {
      setState(() {
        isBackLoading = value;
      });
    }
  }

  void uploadKycImage(XFile file, String type) async {
    setLoading(true, type);
    // 讀取文件內容
    List<int> bytes = await file.readAsBytes();
    int fileSizeInBytes = bytes.length;
    int maxSizeInBytes = 5 * 1024 * 1024; // 5MB

    // 檢查文件大小是否超過5MB
    if (fileSizeInBytes > maxSizeInBytes && mounted) {
      // 如果文件大小超過5MB，顯示提示信息
      showConfirmDialog(
        context: context,
        title: '圖片大小超過5MB',
        content: '請重新選擇圖片，圖片大小不能超過5MB',
        onConfirm: () => Navigator.pop(context),
      );
      return; // 中止上傳操作
    }

    var sid = const Uuid().v4();

    try {
      var form = dio.FormData.fromMap({
        'sid': sid,
        'photo': dio.MultipartFile.fromBytes(
          await file.readAsBytes(),
          filename: file.name,
          contentType:
              http_parser.MediaType.parse(file.mimeType ?? 'image/png'),
        ),
      });

      var res = await fetcher(
        url: '${systemController.apiHost.value}/api/v1/third/photo/upload-kyc',
        method: 'POST',
        form: form,
      );

      dynamic sidRes = res.data; // 將res的data部分存儲在一個動態變數中

      if (sidRes['code'] == '00') {
        String photoSid = sidRes['data']['id'];

        logger.i('uploadKycImage: ${sidRes['data']['id']}');
        logger.i('file.name: ${file.name}');

        setState(() {
          if (type == 'front') {
            frontImagePath = file.path;
            frontImageSid = photoSid;
          } else if (type == 'back') {
            backImagePath = file.path;
            backImageSid = photoSid;
          }
        });

        logger.i('frontImageSid: $frontImageSid');
        logger.i('backImageSid: $backImageSid');
      }

      setLoading(false, type);
    } catch (e) {
      // Handle error
      logger.i('uploadKycImage error: $e');
      setLoading(false, type);
      if (mounted) {
        showRegisterFailDialog(
            context, responseController.responseMessage.value);
      }
    }
  }

  onSubmit() async {
    try {
      if (frontImageSid != null && backImageSid != null) {
        // Call API to bind id card
        GameLobbyApi gameLobbyApi = GameLobbyApi();
        var res = await gameLobbyApi.registerKycApply(
          idFront: frontImageSid!,
          idBack: backImageSid!,
        );

        if (res.code == '00' && mounted) {
          Fluttertoast.showToast(
            msg: '提交成功，請等待人員審核',
            gravity: ToastGravity.CENTER,
          );
          Get.find<GameStartupController>().goBackToAppHome(context);
        }
      }
    } catch (e) {
      logger.e('handleNextStep error: $e');
      if (mounted) {
        showRegisterFailDialog(
            context, responseController.responseMessage.value);
      }
    }
  }

  void _openBottomSheet(BuildContext context, String type) {
    final currentContext = context; // 將 BuildContext 存儲在一個變量中

    showModalBottomSheet(
      context: currentContext,
      backgroundColor: gameLobbyBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.cloud_upload_outlined,
                color: gameLobbyPrimaryTextColor,
              ),
              title: Text(
                '上傳圖片',
                style: TextStyle(
                  fontSize: 14,
                  color: gameLobbyPrimaryTextColor,
                ),
              ),
              onTap: () async {
                // Upload image logic
                XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  uploadKycImage(image, type);
                }

                Navigator.pop(
                    currentContext.mounted ? currentContext : context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt_outlined,
                color: gameLobbyPrimaryTextColor,
              ),
              title: Text(
                '使用相機',
                style: TextStyle(
                  fontSize: 14,
                  color: gameLobbyPrimaryTextColor,
                ),
              ),
              onTap: () async {
                // Use camera logic
                final image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (image != null) {
                  uploadKycImage(image, type);
                }

                Navigator.pop(
                    currentContext.mounted ? currentContext : context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        centerTitle: true,
        title: Text(
          '身分證驗證',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: gameLobbyAppBarTextColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: gameLobbyBgColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  InkWell(
                    onTap: () => _openBottomSheet(context, 'front'),
                    child: AspectRatio(
                      aspectRatio: 359 / 215, // 設置寬高比例
                      child: Container(
                        decoration: BoxDecoration(
                          color: gameLobbyDialogColor2,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                        ),
                        child: frontImagePath != null
                            ? Image.network(frontImagePath!)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: gamePrimaryButtonColor,
                                          width: 2),
                                      color: gameLobbyButtonDisableColor,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: gameLobbyPrimaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '上傳身分證正面',
                                    style: TextStyle(
                                      color: gameLobbyPrimaryTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  if (isFrontLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: GameLoading(),
                        ),
                      ),
                    ),
                  if (frontImagePath != null)
                    Positioned(
                      right: 15,
                      bottom: 15,
                      child: InkWell(
                        onTap: () {
                          _openBottomSheet(context, 'front');
                        },
                        child: Container(
                          width: 60,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: gamePrimaryButtonColor),
                            color: const Color(0xFF2E3136).withOpacity(0.8),
                          ),
                          child: const Center(
                            child: Text(
                              '編輯',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Stack(
                children: [
                  InkWell(
                    onTap: () => _openBottomSheet(context, 'back'),
                    child: AspectRatio(
                      aspectRatio: 359 / 215, // 設置寬高比例
                      child: Container(
                        decoration: BoxDecoration(
                          color: gameLobbyDialogColor2,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                        ),
                        child: backImagePath != null
                            ? Image.network(backImagePath!)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: gamePrimaryButtonColor,
                                          width: 2),
                                      color: gameLobbyButtonDisableColor,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: gameLobbyPrimaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '上傳身分證反面',
                                    style: TextStyle(
                                      color: gameLobbyPrimaryTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  if (isBackLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: GameLoading(),
                        ),
                      ),
                    ),
                  if (backImagePath != null)
                    Positioned(
                      right: 15,
                      bottom: 15,
                      child: InkWell(
                        onTap: () {
                          _openBottomSheet(context, 'back');
                        },
                        child: Container(
                          width: 60,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: gamePrimaryButtonColor),
                            color: const Color(0xFF2E3136).withOpacity(0.8),
                          ),
                          child: const Center(
                            child: Text(
                              '編輯',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '檔案限制 5MB 以下、僅接受 jpg、jpeg 檔案格式',
                style: TextStyle(
                  color: gameLobbyPrimaryTextColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              GameButton(
                  text: '提交',
                  disabled: frontImageSid == null || backImageSid == null,
                  onPressed: () => onSubmit()),
            ],
          ),
        ),
      ),
    );
  }
}
