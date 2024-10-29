// UpdatePasswordPage , has button , click push to '/register'

import 'package:app_wl_cn1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/user_controller.dart';
import '../localization/i18n.dart'; // Added import

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

final logger = Logger();

final userApi = UserApi();

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  UpdatePasswordPageState createState() => UpdatePasswordPageState();
}

class UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _originPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserController userController = Get.find<UserController>();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return I18n.pleaseEnterYourPassword;
    }
    if (!RegExp(r'^[a-zA-Z0-9]{8,20}$').hasMatch(value)) {
      return I18n.passwordLength8To20CharactersAndNumbers;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return I18n.pleaseEnterTheVerificationPassword;
    }
    if (value != _passwordController.text) {
      return I18n.validatePasswordMismatch;
    }
    return null;
  }

  void _handleUpdatePassword(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        var res = await userApi.updatePassword(
            _originPasswordController.text, _passwordController.text);
        logger.i('register success $res, ${res['code']}');

        if (res['code'] == '00') {
          userController.fetchUserInfo();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                I18n.passwordSavedSuccessfully,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
          Navigator.pop(context);
        } else {
          showConfirmDialog(
            context: context,
            title: I18n.passwordError,
            message: I18n.originalPasswordIncorrect,
            showCancelButton: false,
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        }
      } catch (error) {
        logger.i(error);
        showConfirmDialog(
          context: context,
          title: I18n.passwordError,
          message: I18n.originalPasswordIncorrect,
          showCancelButton: false,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: I18n.modifyPassword),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    AuthTextField(
                      label: I18n.originalPassword,
                      obscureText: true,
                      controller: _originPasswordController,
                      placeholderText: I18n.enterOriginalPassword,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: I18n.newPassword,
                      obscureText: true,
                      controller: _passwordController,
                      placeholderText: I18n.pleaseEnterYourPassword,
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: I18n.verifyPassword,
                      obscureText: true,
                      controller: _confirmPasswordController,
                      placeholderText: I18n.pleaseEnterTheVerificationPassword,
                      validator: _validateConfirmPassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Button(
                        text: I18n.confirmEdit,
                        type: 'secondary',
                        onPressed: () {
                          _handleUpdatePassword(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
