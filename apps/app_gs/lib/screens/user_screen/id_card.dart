import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_gs/widgets/button.dart';
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

  RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 3.0);
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
  print('File saved: $result');

  // 顯示保存成功提示
  ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
    const SnackBar(
      content: Text(
        '已成功保存身份卡',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

class QRCodePopup extends StatelessWidget {
  const QRCodePopup({Key? key}) : super(key: key);

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
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00386A),
              Color(0xFF000916),
              Color(0xFF003F6C),
              Color(0xFF005B9C),
            ],
            stops: [0.032, 0.2198, 0.8544, 0.9092],
            // transform: GradientRotation(
            //     156.33 * (3.141592 / 180)), // Convert degrees to radians
          ),
        ),
        child: ContentAndButton(),
      ),
    );
  }
}

class ContentAndButton extends StatefulWidget {
  const ContentAndButton({Key? key}) : super(key: key);

  @override
  _ContentAndButtonState createState() => _ContentAndButtonState();
}

class _ContentAndButtonState extends State<ContentAndButton> {
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
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(66, 119, 220, 0),
                    Color.fromRGBO(67, 120, 220, 0.5),
                  ],
                  stops: [0, 1],
                ),
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'G 點視頻',
                      style: TextStyle(
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
                      '用於找回帳號，請妥善保存，請勿露餡',
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
                    child: QrImage(
                      data: userController.loginCode.value,
                      version: QrVersions.auto,
                      size: 95.0,
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 2, 44, 108),
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
                      child: const Text(
                        '官網地址 : gdtv.app',
                        style: TextStyle(
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
          const Button(
            text: '請截圖保存',
            size: 'small',
            type: 'secondary',
            onPressed: _captureAndSaveScreenshot,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
