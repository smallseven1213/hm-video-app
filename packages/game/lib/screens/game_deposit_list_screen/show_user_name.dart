import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:logger/logger.dart';

import '../../localization/i18n.dart';

final logger = Logger();

void showUserName(
  BuildContext context, {
  required Function(String userName) onSuccess,
  Function()? onClose,
}) {
  final userNameController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();

  showFormDialog(
    context,
    title: I18n.pleaseEnterYourRealName,
    content: FormBuilder(
      key: formKey,
      onChanged: () {
        formKey.currentState!.save();
      },
      child: FormBuilderField<String?>(
        name: 'userName',
        onChanged: (val) => logger.i(val.toString()),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
            errorText: I18n.pleaseEnterYourRealName,
          ),
          FormBuilderValidators.minLength(2, errorText: '請填寫正確姓名'),
          FormBuilderValidators.maxLength(6, errorText: '請填寫正確姓名'),
        ]),
        builder: (FormFieldState field) {
          logger.i('field: $field  ${field.errorText}');
          return TextField(
            controller: userNameController,
            onChanged: (value) => field.didChange(value),
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: I18n.pleaseEnterYourRealName,
              errorText: field.errorText,
              hintStyle: TextStyle(
                color: gameLobbyPrimaryTextColor,
                fontSize: 14,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: gameLobbyDividerColor,
                ),
              ),
            ),
          );
        },
      ),
    ),
    onConfirm: () {
      if (formKey.currentState!.validate()) {
        logger.i('on confirm ${userNameController.text}');
        Navigator.of(context).pop();
        onSuccess(userNameController.text);
      }
    },
    onCancel: () {
      Navigator.of(context).pop();
    },
  );
}
