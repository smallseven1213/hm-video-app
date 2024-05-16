import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:game/screens/game_theme_config.dart';
import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class MobileNumberFormField extends StatefulWidget {
  const MobileNumberFormField({
    Key? key,
    required this.controller,
    required this.field,
    required this.handleButtonEnable,
  }) : super(key: key);

  final TextEditingController controller;
  final FormFieldState field;
  final Function(bool) handleButtonEnable;

  @override
  MobileNumberFormFieldState createState() => MobileNumberFormFieldState();
}

class MobileNumberFormFieldState extends State<MobileNumberFormField> {
  String phoneRegExp = '^(09|9)\\d{8}\$';

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return TextFormField(
      controller: widget.controller,
      onChanged: (value) => {
        widget.field.didChange(value),
        logger.i('value: $value'),
        value.isNotEmpty && RegExp(phoneRegExp).hasMatch(value)
            ? widget.handleButtonEnable(true)
            : widget.handleButtonEnable(false),
      },
      decoration: InputDecoration(
        hintText: localizations.translate('plz_enter_phone_number'),
        hintStyle: TextStyle(color: gameLobbyLoginPlaceholderColor),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.cancel,
            color: gameLobbyIconColor,
            size: 16,
          ),
          onPressed: () {
            widget.handleButtonEnable(false);
            widget.controller.clear();
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: gameLobbyLoginFormBorderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: gameLobbyLoginFormBorderColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: gameLobbyLoginFormBorderColor,
          ),
        ),
        fillColor: const Color(0xFFE5F6F2), // 背景色
        filled: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '+${gameConfigController.countryCode.value!}',
            style: TextStyle(
              color: gameLobbyLoginFormColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
      style: TextStyle(
        color: gameLobbyPrimaryTextColor,
        fontSize: 14,
      ),
      keyboardType: TextInputType.number,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
          errorText: localizations.translate('plz_enter_phone_number'),
        ),
        FormBuilderValidators.match(
          phoneRegExp,
          errorText: localizations.translate('phone_number_format_error'),
        ),
      ]),
    );
  }
}
