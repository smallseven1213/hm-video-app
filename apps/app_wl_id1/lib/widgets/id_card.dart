import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';

import 'package:shared/controllers/user_controller.dart';
import 'package:shared/widgets/capture_screenshot_button.dart';

import '../localization/i18n.dart';

final GlobalKey _globalKey = GlobalKey();

// 定義顏色常量
const Color primaryColor = Color(0xff133362); // 主要顏色
const Color secondaryColor = Color(0xff979797); // 次要顏色
const Color qrCodeColor = Color.fromARGB(255, 2, 44, 108); // 二維碼顏色
const Color backgroundColor = Colors.white; // 背景顏色

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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Text(
                    I18n.accountRecoveryInstructions,
                    style: const TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
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
                    backgroundColor: backgroundColor,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: qrCodeColor,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: qrCodeColor,
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
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Text(
                    '${I18n.website}idstv.app',
                    style: TextStyle(color: backgroundColor, fontSize: 12),
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
                  height: 28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: backgroundColor,
                    ),
                    child: CaptureScreenshotButton(
                      buttonKey: _globalKey,
                      successMessage: I18n.identityCardHasBeenSuccessfullySaved,
                      child: Center(
                        child: Text(I18n.pleaseSaveTheScreenshot),
                      ),
                    ),
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
