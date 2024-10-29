// LoginPage , has button , click push to '/register'

import 'package:flutter/material.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/login/login_scaffold.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:app_wl_tw2/config/colors.dart';
import 'package:app_wl_tw2/widgets/custom_app_bar.dart';
import 'package:app_wl_tw2/widgets/forgot_password_button.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: I18n.login,
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
                  const SizedBox(height: 80),
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
                  const SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: I18n.login,
                      onPressed: () => handleLogin(),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          MyRouteDelegate.of(context)
                              .push(AppRoutes.register, deletePreviousCount: 1);
                        },
                        child: Column(children: [
                          Text(
                            I18n.noAccountYet,
                            style: TextStyle(
                              color: AppColors.colors[ColorKeys.textPrimary],
                            ),
                          ),
                        ]),
                      ),
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
              )),
            )),
      ),
    );
  }
}
