import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';

import 'package:shared/controllers/user_controller.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/widgets/capture_screenshot_button.dart';

final GlobalKey _globalKey = GlobalKey();

class IDCard extends StatelessWidget {
  const IDCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: 270,
        height: 420,
        // 白色背景, radius 4
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                      // child: QrImageView(
                      //   data: 'This QR code has an embedded image as well',
                      //   version: QrVersions.auto,
                      //   size: 130,
                      //   gapless: false,
                      //   embeddedImage: const AssetImage(
                      //       'assets/images/video_preview_hot_icon.png'),
                      //   embeddedImageStyle: const QrEmbeddedImageStyle(
                      //     size: Size(74, 74),
                      //   ),
                      // ),
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
        const Text(
          '抖音成人版',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          '用於找回帳號，請妥善保存，請勿洩露',
          style: TextStyle(
            color: Color(0xFF505159),
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
            child: UserInfoConsumer(
              child: (info, isVIP, isGuest) {
                return Text(
                  "ID:${info.uid}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        CaptureScreenshotButton(
          buttonKey: _globalKey,
          successMessage: '已成功保存身份卡',
          child: Container(
            height: 45,
            width: 230,
            decoration: BoxDecoration(
              color: const Color(0xFFfe2c55),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Center(
              child: Text(
                '請截圖保存',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
            '官方地址：MXTV.APP',
            style: TextStyle(
              // color: AppColors.colors[ColorKeys.buttonBgPrimary],
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
