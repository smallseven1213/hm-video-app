import 'dart:io';
import 'dart:ui';

import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/modules/user/user_promo_consumer.dart';

import '../widgets/button.dart';
import '../widgets/my_app_bar.dart';

final GlobalKey _globalKey = GlobalKey();
final logger = Logger();

Future<void> _captureAndSaveScreenshot() async {
  // 請求權限
  if (Platform.isAndroid) {
    await Permission.storage.request();
  }

  RenderRepaintBoundary boundary =
      // ignore: use_build_context_synchronously
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
  logger.i('File saved: $result');

  // 顯示保存成功提示
  ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
    const SnackBar(
      content: Text(
        '已成功保存推廣卡',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            child: Image(
              width: double.infinity,
              fit: BoxFit.fill,
              image: AssetImage('assets/images/share_page_bg.webp'),
            ),
          ),
          MyAppBar(
            title: I18n.promotionalShare,
            backgroundColor: Colors.transparent,
            actions: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // MyRouteDelegate.of(context)
                    //     .push(AppRoutes.login.value, deletePreviousCount: 1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      I18n.promotionRecord,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          RepaintBoundary(
            key: _globalKey,
            child: Center(
              child: Container(
                width: 270,
                height: 410,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const ContentAndButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContentAndButton extends StatefulWidget {
  const ContentAndButton({Key? key}) : super(key: key);

  @override
  ContentAndButtonState createState() => ContentAndButtonState();
}

class ContentAndButtonState extends State<ContentAndButton> {
  @override
  Widget build(BuildContext context) {
    return UserPromoConsumer(
      child: (promoteData) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 184,
              child: Stack(
                children: [
                  const Image(
                    image: AssetImage('assets/images/user/idcard-bg.webp'),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFb4b1b1),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: QrImageView.withQr(
                            qr: QrCode.fromData(
                                data: '123123123',
                                errorCorrectLevel:
                                    QrErrorCorrectLevel.L), // 替換為您的 QrCode 物件
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Colors.grey, // 設置眼睛顏色為灰色
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Colors.grey, // 設置數據模塊顏色為灰色
                            ),
                            embeddedImage: const AssetImage(
                                'assets/images/video_preview_hot_icon.png'), // 替換為您的圖片路徑
                            embeddedImageStyle: const QrEmbeddedImageStyle(
                              size: Size(40, 40), // 設置圖片大小為 40x40
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${promoteData.promotedMembers}${I18n.countPersonPromotion}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              I18n.promoted,
              style: const TextStyle(
                color: Color(0xFF505159),
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 25,
              padding: const EdgeInsets.symmetric(
                horizontal: 27.4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFffd0d9),
                borderRadius: BorderRadius.circular(12.5),
              ),
              child: Center(
                child: Text(
                  "${I18n.invitationCode} ${promoteData.invitationCode}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Button(
                text: I18n.copyAndShare,
                type: 'primary',
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: "https://${promoteData.promoteLink}"));
                  ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
                    SnackBar(
                      content: Text(
                        I18n.successfullyCopied,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Button(
                text: I18n.screenShortShare,
                type: 'primary',
                onPressed: _captureAndSaveScreenshot,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
