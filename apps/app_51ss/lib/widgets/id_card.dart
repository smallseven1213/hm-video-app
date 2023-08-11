import 'dart:ui';
import 'dart:io';

import 'package:app_51ss/config/colors.dart';
import 'package:app_51ss/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared/models/color_keys.dart';

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
        width: 290,
        height: 460,
        padding: const EdgeInsets.all(15),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 290,
            height: 125,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/user/share-top.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            width: 290,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/user/share-center.png'),
                repeat: ImageRepeat.repeatY,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '用於找回帳號，請妥善保存，請勿洩露',
                  style: TextStyle(
                    color: AppColors.colors[ColorKeys.textSecondary],
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('ID: ${userController.info.value.uid}'),
                const SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 165,
                  height: 30,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffb5925c).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Text(
                    '官方地址：51ss.tv',
                    style: TextStyle(
                      color: AppColors.colors[ColorKeys.buttonBgPrimary],
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          Container(
            width: 290,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/user/share-bottom.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Button(
                    text: '請截圖保存',
                    type: 'secondary',
                    onPressed: _captureAndSaveScreenshot,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
