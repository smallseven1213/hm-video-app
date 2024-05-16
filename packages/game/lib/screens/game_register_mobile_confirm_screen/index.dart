import 'dart:async';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/screens/game_register_mobile_confirm_screen/count_down_timer.dart';
import 'package:game/widgets/game_startup.dart';

import 'package:shared/controllers/game_platform_config_controller.dart';

import '../../localization/game_localization_delegate.dart';
import 'confirm_pin.dart';

final logger = Logger();

class GameRegisterMobileConfirm extends StatefulWidget {
  final String parsePhoneNumber;
  const GameRegisterMobileConfirm({Key? key, required this.parsePhoneNumber})
      : super(key: key);

  @override
  GameRegisterMobileConfirmState createState() =>
      GameRegisterMobileConfirmState();
}

class GameRegisterMobileConfirmState extends State<GameRegisterMobileConfirm> {
  GameBannerController gameBannerController = Get.find<GameBannerController>();
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();

  bool hasError = false;

  void handleOtpResError(bool value) {
    setState(() {
      hasError = value;
    });
  }

  void handleSubmitOtp(String otp) async {
    try {
      var res = await GameLobbyApi().registerMobileConfirm(
        countryCode: gameConfigController.countryCode.value!,
        phoneNumber: widget.parsePhoneNumber,
        otp: otp,
      );
      if (res.code == '00' && mounted) {
        handleOtpResError(false);

        Fluttertoast.showToast(
          msg: GameLocalizations.of(context)!
              .translate('registration_successful'),
          gravity: ToastGravity.CENTER,
        );

        Get.find<GameStartupController>().goBackToAppHome(context);
      }
    } catch (e) {
      logger.e('submitMobileConfirmOtp error: $e');

      errorController.add(ErrorAnimationType.shake);
      handleOtpResError(true);
    }
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: gameLobbyBgColor,
          centerTitle: true,
          title: Text(
            localizations.translate('otp_verification_enter_code'),
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 40,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            color: gameLobbyBgColor,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${localizations.translate('otp_verification_prompt')}${gameConfigController.countryCode.value}${widget.parsePhoneNumber}${localizations.translate('otp_verification_code_suffix')}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: gameLobbyPrimaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      localizations.translate('otp_code'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: gameLobbyPrimaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ConfirmPin(
                      textEditingController: textEditingController,
                      errorController: errorController,
                      handleSubmitOtp: handleSubmitOtp,
                      hasError: hasError,
                    ),
                    CountdownTimer(parsePhoneNumber: widget.parsePhoneNumber),
                    const SizedBox(height: 80),
                    Center(
                      child: InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(
                              gameBannerController.customerServiceUrl.value));
                        },
                        child: Text(
                          localizations.translate('otp_unable_to_get_code'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF3d73ff),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
