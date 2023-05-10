import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/showFormDialog.dart';

void showUserName(
  BuildContext context, {
  required Function(String userName) onSuccess,
  Function()? onClose,
}) {
  final userNameController = TextEditingController();
  final formKey = GlobalKey<FormBuilderState>();

  final formDialog = showFormDialog(
    context,
    title: '輸入真實姓名',
    content: FormBuilder(
      key: formKey,
      onChanged: () {
        formKey.currentState!.save();
      },
      child: FormBuilderField<String?>(
        name: 'userName',
        onChanged: (val) => debugPrint(val.toString()),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
            errorText: '請輸入真實姓名',
          ),
          FormBuilderValidators.minLength(2, errorText: '請填寫正確姓名'),
          FormBuilderValidators.maxLength(6, errorText: '請填寫正確姓名'),
        ]),
        builder: (FormFieldState field) {
          print('field: $field  ${field.errorText}');
          return TextField(
            controller: userNameController,
            onChanged: (value) => field.didChange(value),
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: '請填寫真實姓名',
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
        print('on confirm ${userNameController.text}');
        Navigator.of(context).pop();
        onSuccess(userNameController.text);
      }
    },
    onCancel: () {
      Navigator.of(context).pop();
    },
  );
}
