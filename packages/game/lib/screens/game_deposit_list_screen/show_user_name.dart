import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:logger/logger.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

void showUserName(
  BuildContext context, {
  required Function(String userName) onSuccess,
  Function()? onClose,
}) {
  final GameLocalizations localizations = GameLocalizations.of(context)!;

  final userNameController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();

  showFormDialog(
    context,
    title:
        GameLocalizations.of(context)!.translate('please_enter_your_real_name'),
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
            errorText: localizations.translate('please_enter_your_real_name'),
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
              hintText: GameLocalizations.of(context)!
                  .translate('please_enter_your_real_name'),
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
