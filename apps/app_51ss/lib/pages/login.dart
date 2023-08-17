// LoginPage , has button , click push to '/register'

import 'package:app_51ss/widgets/custom_app_bar.dart';
import 'package:app_51ss/widgets/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/modules/login/login_scaffold.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';

final logger = Logger();
final authApi = AuthApi();

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入帳號';
    }
    // 可在此添加其他驗證邏輯
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    // 可在此添加其他驗證邏輯
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: '登入',
        ),
        body: LoginPageScaffold(
          showErrorDialog: () {
            showConfirmDialog(
              context: context,
              title: '登入錯誤',
              message: '帳號或密碼不正確',
              showCancelButton: false,
              onConfirm: () => {},
            );
          },
          child: (accountController, passwordController) {
            return Column(
              children: [
                AuthTextField(
                  label: '帳號',
                  controller: accountController,
                  placeholderText: '請輸入帳號',
                  validator: _validateUsername,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  label: '密碼',
                  controller: passwordController,
                  placeholderText: '請輸入密碼',
                  obscureText: true,
                  validator: _validatePassword,
                ),
              ],
            );
          },
          forgetPasswordButton: const ForgotPasswordButton(),
        ));
  }
}
