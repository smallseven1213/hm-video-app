// LoginPage , has button , click push to '/register'

import 'package:flutter/material.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/login/login_scaffold.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';
import '../widgets/forgot_password_button.dart';
import '../widgets/custom_app_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: '會員登入',
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: LoginPageScaffold(
              onError: (title, message) {
                showConfirmDialog(
                  context: context,
                  title: title,
                  message: message,
                  showCancelButton: false,
                  onConfirm: () {},
                );
              },
              child: (
                accountController,
                passwordController,
                validateUsername,
                validatePassword,
                handleLogin,
              ) =>
                  SingleChildScrollView(
                      child: Column(
                children: [
                  const SizedBox(height: 30),
                  AuthTextField(
                    label: '帳號',
                    controller: accountController,
                    placeholderText: '請輸入帳號',
                    validator: validateUsername,
                  ),
                  AuthTextField(
                    label: '密碼',
                    controller: passwordController,
                    placeholderText: '請輸入密碼',
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: '登入',
                      onPressed: () => handleLogin(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          MyRouteDelegate.of(context)
                              .push(AppRoutes.register, deletePreviousCount: 1);
                        },
                        child: const Text(
                          '註冊',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const ForgotPasswordButton(),
                    ],
                  ),
                ],
              )),
            )),
      ),
    );
  }
}
