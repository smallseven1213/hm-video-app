import 'package:app_wl_id1/localization/i18n.dart';
import 'dart:ui';
import 'dart:io';

import 'package:app_wl_id1/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey _globalKey = GlobalKey();

Future<void> _captureAndSaveScreenshot() async {
  // 請求權限
  if (Platform.isAndroid) {
    await Permission.storage.request();
  }

  // Get the RenderObject before the async operation
  RenderObject? renderObject = _globalKey.currentContext?.findRenderObject();

  if (renderObject is RenderRepaintBoundary) {
    final image = await renderObject.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // 獲取應用文檔目錄
    Directory directory = await getTemporaryDirectory();
    String tempPath = directory.path;

    // 生成文件名
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

    // 保存到臨時文件
    File file = File('$tempPath/$fileName');
    await file.writeAsBytes(pngBytes);

    // 保存到相冊
    final result = await ImageGallerySaver.saveFile(file.path);
    logger.i('File saved: $result');

    // 顯示保存成功提示
    // 注意这里我们再次获取context，因为此处的context可能已经发生改变
    ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          I18n.identityCardHasBeenSuccessfullySaved,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class IDCard extends StatelessWidget {
  const IDCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: 270,
        height: 400,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          borderRadius: kIsWeb ? null : BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00386A),
              Color.fromRGBO(0, 9, 22, 1),
              Color(0xFF003F6C),
              Color(0xFF005B9C),
            ],
            stops: [0.03, 0.22, 0.85, 0.91],
            // transform: GradientRotation(
            //     156.33 * (3.141592 / 180)), // Convert degrees to radians
          ),
        ),
        child: const IDCardContent(),
      ),
    );
  }
}

class IDCardContent extends StatefulWidget {
  const IDCardContent({Key? key}) : super(key: key);

  @override
  IDCardContentState createState() => IDCardContentState();
}

class IDCardContentState extends State<IDCardContent> {
  UserController get userController => Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.getLoginCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add the content widget here
                  // 1. App icon
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      'assets/images/app_title.png',
                      width: 130,
                      height: 30,
                    ),
                  ),

                  // 2. Platform title
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      I18n.gPointVideo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // 3. Info text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      I18n.accountRecoveryInstructions,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        // height: 20 / 12,
                      ),
                    ),
                  ),

                  // 4. ID text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'ID: ${userController.info.value.uid}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  // 5. QR Code image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QrImageView(
                      data: userController.loginCode.value,
                      version: QrVersions.auto,
                      size: 95.0,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color.fromARGB(255, 2, 44, 108),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color.fromARGB(255, 2, 44, 108),
                      ),
                    ),
                  ),

                  // 6. Rounded background text
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(66, 119, 220, 0.5),
                      ),
                      width: 115,
                      child: Text(
                        '${I18n.website}gdtv.app',
                        style: const TextStyle(
                          color: Color(0xFF21AFFF),
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      )),
                ],
              ),
            ),
          ),

          // Add the button widget here
          const SizedBox(height: 33),
          SizedBox(
            width: 208,
            child: Button(
              text: I18n.pleaseSaveTheScreenshot,
              type: 'secondary',
              onPressed: _captureAndSaveScreenshot,
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
