// RegisterPage , has button , click push to '/register'

import 'package:app_51ss/config/colors.dart';
import 'package:app_51ss/widgets/custom_app_bar.dart';
import 'package:app_51ss/widgets/forgot_password_button.dart';

import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/register/register_scaffold.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '註冊',
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
                const SizedBox(height: 80),
                Column(
                  children: [
                    AuthTextField(
                      label: '帳　　號',
                      controller: accountController,
                      placeholderText: '請輸入帳號',
                      validator: validateUsername,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '密　　碼',
                      obscureText: true,
                      controller: passwordController,
                      placeholderText: '請輸入密碼',
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '驗證密碼',
                      obscureText: true,
                      controller: confirmPasswordController,
                      placeholderText: '請輸入驗證密碼',
                      validator: validateConfirmPassword,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: 240,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Button(
                          text: '註冊',
                          type: 'primary',
                          onPressed: () {
                            handleRegister();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Button(
                          text: '取消',
                          type: 'cancel',
                          onPressed: () {
                            MyRouteDelegate.of(context).popRoute();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          GestureDetector(
                            onTap: () {
                              MyRouteDelegate.of(context).push(AppRoutes.login,
                                  deletePreviousCount: 1);
                            },
                            child: Column(children: [
                              Text('前往登入',
                                  style: TextStyle(
                                      color: AppColors
                                              .colors[ColorKeys.textPrimary]
                                          as Color)),
                            ]),
                          )
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: 1,
                            height: 12,
                            color: AppColors.colors[ColorKeys.menuColor],
                          ),
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
      ),
    );
  }
}
