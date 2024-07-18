import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/on_loading.dart';
import 'package:game/widgets/button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class ConfirmPin extends StatefulWidget {
  final String amount;
  final String paymentChannelId;
  final String activePayment;
  final String? userName;

  const ConfirmPin({
    Key? key,
    required this.amount,
    required this.paymentChannelId,
    required this.activePayment,
    this.userName,
  }) : super(key: key);

  @override
  ConfirmPinState createState() => ConfirmPinState();
}

class ConfirmPinState extends State<ConfirmPin> {
  String _code = '';
  bool enableSubmit = false;
  bool hasError = false;
  String currentText = '';
  String redirectUrl = '';
  bool submitDepositSuccess = false;
  String isFetching = '';

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();

  void submitDepositOrderForPin(
    context, {
    required String amount,
    required int paymentChannelId,
    required String? userName,
    required String activePayment,
  }) async {
    try {
      var value = await GameLobbyApi().makeOrderV2(
        amount: widget.amount,
        paymentChannelId: int.parse(widget.paymentChannelId),
        name: widget.userName,
      );
      setState(() {
        redirectUrl = value;
        submitDepositSuccess = true;
        isFetching = 'complete';
      });
    } catch (e) {
      logger.e('pin 交易失敗: $e');
      setState(() {
        submitDepositSuccess = false;
        isFetching = 'complete';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 隨機產生四位數的驗證碼
    _code = Random().nextInt(9999).toString().padLeft(4, '0');
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('_code: $_code');
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      height: 355,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Image.asset(
            'packages/game/assets/images/game_deposit/deposit_confirm-$theme.webp',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          '${localizations.translate('deposit_amount')}：${widget.amount}${localizations.translate('dollar')}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: gameLobbyPrimaryTextColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Divider(
            color: gameLobbyDividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Text(
            _code,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: gameLobbyPrimaryTextColor,
                letterSpacing: 10),
          ),
        ),
        FormBuilder(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
            },
            child: PinCodeTextField(
              appContext: context,
              pastedTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              length: 4,
              obscureText: false,
              obscuringCharacter: '*',
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 55,
                fieldWidth: 50,
                activeColor: gameLobbyLoginFormBorderColor,
                selectedColor: gameLobbyLoginFormBorderColor,
                inactiveColor: gameLobbyLoginFormBorderColor,
                errorBorderColor: Colors.red,
              ),
              cursorColor: gameLobbyPrimaryTextColor,
              animationDuration: const Duration(milliseconds: 300),
              textStyle:
                  TextStyle(fontSize: 20, color: gameLobbyPrimaryTextColor),
              enableActiveFill: false,
              errorAnimationController: errorController,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              onCompleted: (v) async {
                _formKey.currentState!.validate();
                if (currentText.length != 4 || currentText != _code) {
                  errorController.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                  setState(() {
                    hasError = true;
                  });
                } else {
                  setState(() {
                    hasError = false;
                    enableSubmit = true;
                  });
                }
                if (hasError == false && enableSubmit == true) {
                  setState(() => isFetching = 'start');
                  submitDepositOrderForPin(
                    context,
                    amount: widget.amount,
                    paymentChannelId: int.parse(widget.paymentChannelId),
                    userName: widget.userName,
                    activePayment: widget.activePayment,
                  );
                }
              },
              onChanged: (value) {
                logger.i(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                logger.i("Allowing to paste $text");
                return true;
              },
            )),

        // 在row輸入框的下方顯示驗證錯誤的訊息，文字是驗證碼錯誤
        if (hasError)
          Align(
              alignment: Alignment.center,
              child: Text(
                localizations.translate('wrong_verification_code'),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )),
        Align(
          alignment: Alignment.center,
          child: Text(
            enableSubmit && isFetching == 'start'
                ? localizations.translate('get_the_link_to_reload')
                : hasError
                    ? ''
                    : submitDepositSuccess && isFetching == 'complete'
                        ? localizations.translate('the_link_was_successful')
                        : !submitDepositSuccess && isFetching == 'complete'
                            ? localizations.translate(
                                'failed_to_get_the_link_to_recharge_please_change_the_recharge_channel_or_contact_customer_service')
                            : localizations.translate(
                                'if_the_order_is_correct_please_enter_the_above_verification_code'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: gameLobbyPrimaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (isFetching == 'complete')
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: 180,
            child: GameButton(
              text: submitDepositSuccess
                  ? localizations.translate('open_top_up_page')
                  : localizations.translate('close'),
              onPressed: () {
                if (submitDepositSuccess) {
                  onLoading(context, status: false);
                  Navigator.pop(context);
                  launchUrl(Uri.parse(redirectUrl),
                      webOnlyWindowName: '_blank');
                  MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult);
                } else {
                  Navigator.pop(context);
                }
              },
              disabled: hasError || !enableSubmit,
            ),
          )
      ]),
    );
  }
}
