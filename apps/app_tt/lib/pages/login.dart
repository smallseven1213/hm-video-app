// LoginPage , has button , click push to '/register'

import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/login/login_scaffold.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:app_tt/config/colors.dart';
import 'package:app_tt/widgets/my_app_bar.dart';
import 'package:app_tt/widgets/forgot_password_button.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: I18n.memberLogin,
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
                    I18n.accountPasswordLogin,
                    style: TextStyle(
                      color: AppColors.colors[ColorKeys.textPrimary],
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  label: I18n.account,
                  controller: accountController,
                  placeholderText: I18n.pleaseEnterYourAccountNumber,
                  validator: validateUsername,
                ),
                const SizedBox(height: 10),
                AuthTextField(
                  label: I18n.password,
                  controller: passwordController,
                  placeholderText: I18n.pleaseEnterYourPassword,
                  obscureText: true,
                  validator: validatePassword,
                ),
                const ForgotPasswordButton(),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: I18n.login,
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
                        I18n.noAccountYet,
                        style: TextStyle(
                          color: AppColors.colors[ColorKeys.textLink],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        I18n.loginWithPhoneNumber,
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
