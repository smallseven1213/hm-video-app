import 'dart:async';

import 'package:game/controllers/game_response_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:game/screens/game_theme_config.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class ConfirmPin extends StatefulWidget {
  final TextEditingController textEditingController;
  final StreamController<ErrorAnimationType> errorController;
  final Function(String otp) handleSubmitOtp;
  final bool hasError;

  const ConfirmPin(
      {Key? key,
      required this.textEditingController,
      required this.errorController,
      required this.handleSubmitOtp,
      required this.hasError})
      : super(key: key);

  @override
  ConfirmPinState createState() => ConfirmPinState();
}

class ConfirmPinState extends State<ConfirmPin> {
  bool enableSubmit = false;
  String currentText = '';
  String errorText = '';

  final _formKey = GlobalKey<FormBuilderState>();
  GameApiResponseErrorCatchController responseController =
      Get.find<GameApiResponseErrorCatchController>();
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      height: 100,
      child: Column(children: [
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
              length: 6,
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
              errorAnimationController: widget.errorController,
              controller: widget.textEditingController,
              keyboardType: TextInputType.number,
              onCompleted: (v) async {
                logger.i('Completed: ${widget.textEditingController.text}');
                _formKey.currentState!.validate();
                setState(() {
                  enableSubmit = true;
                });
                widget.handleSubmitOtp(
                  widget.textEditingController.text,
                );
              },
              onChanged: (value) => logger.i(value),
              beforeTextPaste: (text) {
                logger.i("Allowing to paste $text");
                return true;
              },
            )),
        if (widget.hasError)
          Align(
              alignment: Alignment.center,
              child: Text(
                responseController.responseMessage.value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )),
      ]),
    );
  }
}
