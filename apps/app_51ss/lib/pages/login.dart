// LoginPage , has button , click push to '/register'

import 'package:app_51ss/widgets/custom_app_bar.dart';
import 'package:app_51ss/widgets/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/login/login_scaffold.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

final logger = Logger();
final authApi = AuthApi();

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: '登入',
        ),
        body: LoginPageScaffold(
          onError: (title, message) {
            showConfirmDialog(
              context: context,
              title: title,
              message: message,
              showCancelButton: false,
              onConfirm: () {
                // Navigator.of(context).pop();
              },
            );
          },
          child: (accountController, passwordController, validateUsername,
                  validatePassword, onLogin) =>
              SingleChildScrollView(
                  child: Column(
            children: [
              const SizedBox(height: 80),
              AuthTextField(
                label: '帳號',
                controller: accountController,
                placeholderText: '請輸入帳號',
                validator: validateUsername,
              ),
              const SizedBox(height: 10),
              AuthTextField(
                label: '密碼',
                controller: passwordController,
                placeholderText: '請輸入密碼',
                obscureText: true,
                validator: validateUsername,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 200,
                child: Button(
                  text: '登入',
                  onPressed: () => onLogin(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      MyRouteDelegate.of(context)
                          .push(AppRoutes.register, deletePreviousCount: 1);
                    },
                    child: const Column(children: [
                      Text('還沒有帳號',
                          style: TextStyle(
                            color: Color(0xFF00B2FF),
                            decoration: TextDecoration.underline,
                          )),
                    ]),
                  ),
                  const ForgotPasswordButton()
                ],
              ),
            ],
          )),
        ));
  }
}
