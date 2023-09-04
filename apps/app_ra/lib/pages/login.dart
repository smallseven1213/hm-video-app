// LoginPage , has button , click push to '/register'

import 'package:flutter/material.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/login/login_scaffold.dart';
import 'package:shared/navigator/delegate.dart';

import '../config/colors.dart';
import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';
import '../widgets/forgot_password_button.dart';
import '../widgets/my_app_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '帳號密碼登入',
                    style: TextStyle(
                      color: AppColors.colors[ColorKeys.textPrimary],
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                  validator: validatePassword,
                ),
                const ForgotPasswordButton(),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: '登入',
                    onPressed: () => handleLogin(),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        MyRouteDelegate.of(context)
                            .push(AppRoutes.register, deletePreviousCount: 1);
                      },
                      child: Text(
                        '還沒有帳號',
                        style: TextStyle(
                          color: AppColors.colors[ColorKeys.textLink],
                          fontSize: 12,
                        ),
                      ),
                    ),
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
            )),
          )),
    );
  }
}
