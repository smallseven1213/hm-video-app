import 'dart:io';
import 'dart:ui';

import 'package:app_wl_ph1/localization/i18n.dart';
import 'package:app_wl_ph1/widgets/button.dart';
import 'package:app_wl_ph1/widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared/modules/user/user_promo_consumer.dart';

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
  final result = await ImageGallerySaverPlus.saveFile(file.path);
  logger.i('File saved: $result');

  // 顯示保存成功提示
  ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(
        I18n.promotionalCardHasBeenSuccessfullySaved,
        style: const TextStyle(color: Colors.white),
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
              image: AssetImage('assets/images/share_bg.webp'),
            ),
          ),
          CustomAppBar(
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
                        color: Color(0xff00B0D4),
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
                height: 400,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00386A),
                      Color.fromRGBO(0, 9, 22, 0.9),
                      Color(0xFF003F6C),
                      Color(0xFF005B9C),
                    ],
                    stops: [0.03, 0.22, 0.85, 0.91],
                  ),
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
      child: (promoteData) => Column(
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

                  // 2. Platform title
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      '${promoteData.promotedMembers} ${I18n.countPersonPromotion}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // 3. Info text
                  Text(
                    I18n.promoted,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      // height: 20 / 12,
                    ),
                  ),

                  // 6. Rounded background text
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 25, bottom: 25),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromRGBO(66, 119, 220, 0.5),
                      ),
                      width: 115,
                      child: Text(
                        '${I18n.invitationCode} ${promoteData.invitationCode}',
                        style: const TextStyle(
                          color: Color(0xFF21AFFF),
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      )),
                  // 5. QR Code image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QrImageView(
                      data: 'https://${promoteData.promoteLink}',
                      version: QrVersions.auto,
                      size: 90.0,
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
                  const SizedBox(height: 30),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Button(
                      text: I18n.copyAndShare,
                      type: 'secondary',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: "https://${promoteData.promoteLink}"));
                        ScaffoldMessenger.of(_globalKey.currentContext!)
                            .showSnackBar(
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Button(
                      text: I18n.screenShortShare,
                      type: 'primary',
                      onPressed: _captureAndSaveScreenshot,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
