import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:game/screens/game_deposit_list_screen/submitDepositOrder.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:get_storage/get_storage.dart';

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
  _ConfirmPinState createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  String _code = '';
  bool enableSubmit = false;
  bool hasError = false;
  String currentText = '';

  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();

  @override
  void initState() {
    super.initState();
    // 隨機產生四位數的驗證碼
    _code = Random().nextInt(9999).toString().padLeft(4, '0');
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    print('_code: $_code');

    return SizedBox(
      height: 360,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Image.asset(
            'packages/game/assets/images/game_deposit/deposit_confirm-$theme.webp',
            width: 65,
            height: 65,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          '存款金額：${widget.amount}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: gameLobbyPrimaryTextColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Divider(
            color: gameLobbyDividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 14),
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
              onCompleted: (v) {
                _formKey.currentState!.validate();
                // conditions for validating
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
                  submitDepositOrder(
                    context,
                    amount: widget.amount,
                    paymentChannelId: int.parse(widget.paymentChannelId),
                    userName: widget.userName,
                    activePayment: widget.activePayment,
                  );
                }
              },
              onChanged: (value) {
                print(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                return true;
              },
            )),

        // 在row輸入框的下方顯示驗證錯誤的訊息，文字是驗證碼錯誤
        if (hasError)
          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '驗證碼錯誤',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '如訂單無誤，請輸入以上驗證碼',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: gameLobbyPrimaryTextColor),
          ),
        ),
      ]),
    );
  }
}
