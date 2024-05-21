// RegisterPage , has button , click push to '/register'
import 'package:app_ra/widgets/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/register/register_scaffold.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';
import '../widgets/my_app_bar.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '會員註冊',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: RegisterPageScaffold(
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
            confirmPasswordController,
            validateUsername,
            validatePassword,
            validateConfirmPassword,
            handleRegister,
          ) =>
              SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Column(
                  children: [
                    AuthTextField(
                      label: '帳號',
                      controller: accountController,
                      placeholderText: '請輸入帳號',
                      validator: validateUsername,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '密碼',
                      obscureText: true,
                      controller: passwordController,
                      placeholderText: '請輸入密碼',
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '確認密碼',
                      obscureText: true,
                      controller: confirmPasswordController,
                      placeholderText: '請輸入確認密碼',
                      validator: validateConfirmPassword,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: '註冊',
                    onPressed: () {
                      handleRegister();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      GestureDetector(
                        onTap: () {
                          MyRouteDelegate.of(context)
                              .push(AppRoutes.login, deletePreviousCount: 1);
                        },
                        child: const Column(children: [
                          Text(
                            '登入',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ]),
                      )
                    ]),
                    const SizedBox(width: 20),
                    const ForgotPasswordButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
