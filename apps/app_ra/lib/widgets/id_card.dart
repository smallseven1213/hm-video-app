import 'dart:ui';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'button.dart';

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
    final result = await ImageGallerySaverPlus.saveFile(file.path);
    logger.i('File saved: $result');

    // 顯示保存成功提示
    // 注意这里我们再次获取context，因为此处的context可能已经发生改变
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
}

class IDCard extends StatelessWidget {
  const IDCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: 270,
        height: 350,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF030923),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFDDCEF),
            width: 2,
          ),
        ),
        child: const Center(
          child: IDCardContent(),
        ),
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
          const SizedBox(height: 10),
          const Image(
            image: AssetImage('assets/images/logo_h.png'),
            width: 130,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              '用於找回帳號，請妥善保存，請勿露餡',
              style: TextStyle(
                color: Colors.white,
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
                color: Color(0xFFFDDCEF),
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
          // Add the button widget here
          const SizedBox(height: 33),
          const SizedBox(
            width: 160,
            child: Button(
              borderColor: Colors.white,
              textColor: Colors.white,
              text: '請截圖保存',
              onPressed: _captureAndSaveScreenshot,
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
