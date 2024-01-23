// RegisterPage , has button , click push to '/register'

import 'package:app_wl_id1/localization/i18n.dart';
import 'package:dio/dio.dart';
import 'package:app_wl_id1/widgets/custom_app_bar.dart';
import 'package:app_wl_id1/widgets/login/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

final logger = Logger();

final authApi = AuthApi();

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserController userController = Get.find<UserController>();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return I18n.pleaseEnterYourAccountNumber;
    }

    if (!RegExp(r'^[a-zA-Z0-9]{6,12}$').hasMatch(value)) {
      return I18n.accountLength6To12LettersNumbers;
    }

    return null;
  }

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
    // 可在此添加其他驗證邏輯
    return null;
  }

  void _handleRegister(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        var res = await authApi.register(
            uid: userController.info.value.uid,
            username: _accountController.text,
            password: _passwordController.text);
        logger.i('register success $res');

        if (res.code == '00') {
          userController.fetchUserInfo();
          MyRouteDelegate.of(context).popRoute();
        } else {
          showConfirmDialog(
            context: context,
            title: I18n.registerError,
            message: I18n.invalidAccountOrPassword,
            showCancelButton: false,
            onConfirm: () {
              // Navigator.of(context).pop();
            },
          );
        }
      } on DioException catch (error) {
        if (error.response?.data['code'] == '40000') {
          showConfirmDialog(
            context: context,
            title: I18n.registerError,
            message: I18n.accountAlreadyExists,
            showCancelButton: false,
            onConfirm: () {
              // Navigator.of(context).pop();
            },
          );
        } else {
          showConfirmDialog(
            context: context,
            title: I18n.registerError,
            message: I18n.invalidAccountOrPassword,
            showCancelButton: false,
            onConfirm: () {
              // Navigator.of(context).pop();
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '註冊',
      ),
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
                      label: I18n.account,
                      controller: _accountController,
                      placeholderText: I18n.pleaseEnterYourAccountNumber,
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: I18n.password,
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
                        text: I18n.register,
                        onPressed: () {
                          _handleRegister(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Button(
                        text: I18n.cancel,
                        type: 'cancel',
                        onPressed: () {
                          MyRouteDelegate.of(context).popRoute();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        GestureDetector(
                          onTap: () {
                            MyRouteDelegate.of(context)
                                .push(AppRoutes.login, deletePreviousCount: 1);
                          },
                          child: Column(children: [
                            Text(I18n.goToLogin,
                                style: const TextStyle(
                                  color: Color(0xFF00B2FF),
                                  decoration: TextDecoration.underline,
                                )),
                          ]),
                        )
                      ]),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 12, // 設置分隔線高度
                        width: 1, // 設置分隔線寬度
                        color: Colors.grey, // 設置分隔線顏色
                      ),
                      const ForgotPasswordButton()
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
