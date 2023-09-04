// RegisterPage , has button , click push to '/register'
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/register/register_scaffold.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../config/colors.dart';
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '帳號密碼註冊',
                    style: TextStyle(
                      color: AppColors.colors[ColorKeys.textPrimary],
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: '註冊',
                    type: 'primary',
                    onPressed: () {
                      handleRegister();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          GestureDetector(
                            onTap: () {
                              MyRouteDelegate.of(context).push(AppRoutes.login,
                                  deletePreviousCount: 1);
                            },
                            child: Column(children: [
                              Text(
                                '帳號密碼登入',
                                style: TextStyle(
                                  color: AppColors.colors[ColorKeys.textLink]
                                      as Color,
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                          )
                        ]),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            '手機號登入',
                            style: TextStyle(
                              color: AppColors.colors[ColorKeys.textLink],
                              fontSize: 12,
                            ),
                          ),
                        ),
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
