import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/user/user_promo_consumer.dart';

import 'package:app_wl_tw1/config/colors.dart';
import 'package:app_wl_tw1/widgets/button.dart';
import 'package:shared/widgets/capture_screenshot_button.dart';
import 'package:app_wl_tw1/widgets/custom_app_bar.dart';

final GlobalKey _globalKey = GlobalKey();
final logger = Logger();

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // HC: 煩死，勿動!!
      child: Scaffold(
        appBar: CustomAppBar(
          title: '推廣分享',
          actions: [
            TextButton(
              onPressed: () {
                // share record
              },
              child: Text(
                '推廣紀錄',
                style: TextStyle(
                  color: AppColors.colors[ColorKeys.buttonTextPrimary],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: AppColors.colors[ColorKeys.primary],
          child: RepaintBoundary(
            key: _globalKey,
            child: Center(
              child: Container(
                width: 300,
                height: 460,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xff5e5a5b), // 邊框顏色
                    width: 15.0, // 邊框寬度
                  ),
                ),
                child: const ContentAndButton(),
              ),
            ),
          ),
        ),
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
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: UserPromoConsumer(
              child: (promoteData) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 2. Platform title

                  Text(
                    '${promoteData.promotedMembers}人推廣',
                    style: TextStyle(
                      color: AppColors.colors[ColorKeys.textPrimary],
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),

                  // 3. Info text
                  Text(
                    '已推廣',
                    style: TextStyle(
                      color: AppColors.colors[ColorKeys.textSecondary],
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      // height: 20 / 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    height: 1,
                    color: AppColors.colors[ColorKeys.dividerColor],
                  ),
                  // 6. Rounded background text
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          top: 25, bottom: 25, left: 14, right: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffb5925c).withOpacity(0.1),
                      ),
                      width: double.infinity,
                      child: Text(
                        '邀請碼 ${promoteData.invitationCode}',
                        style: TextStyle(
                          color: AppColors.colors[ColorKeys.buttonBgPrimary],
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      )),
                  // 5. QR Code image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: QrImageView(
                      data: promoteData.promoteLink,
                      version: QrVersions.auto,
                      size: 150.0,
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
                  const SizedBox(height: 25),
                  Button(
                    text: '複製分享',
                    type: 'primary',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: "https://${promoteData.promoteLink}"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '複製成功',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.colors[ColorKeys.buttonBgSecondary],
                    ),
                    child: CaptureScreenshotButton(
                      buttonKey: _globalKey,
                      successMessage: '已成功保存推廣卡',
                      child: Center(
                        child: Text(
                          '截圖分享',
                          style: TextStyle(
                              color: AppColors
                                      .colors[ColorKeys.buttonTextSecondary]
                                  as Color),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
