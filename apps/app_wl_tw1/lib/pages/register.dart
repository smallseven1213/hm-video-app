// RegisterPage , has button , click push to '/register'

import 'package:app_wl_tw1/config/colors.dart';
import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:app_wl_tw1/widgets/forgot_password_button.dart';

import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/register/register_scaffold.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';
import '../localization/i18n.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: I18n.signup,
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
                        label: I18n.account,
                        controller: accountController,
                        placeholderText: I18n.pleaseEnterYourAccount,
                        validator: validateUsername,
                      ),
                      const SizedBox(height: 10),
                      AuthTextField(
                        label: I18n.password,
                        obscureText: true,
                        controller: passwordController,
                        placeholderText: I18n.pleaseEnterYourPassword,
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 10),
                      AuthTextField(
                        label: I18n.verifyPassword,
                        obscureText: true,
                        controller: confirmPasswordController,
                        placeholderText:
                            I18n.pleaseEnterTheVerificationPassword,
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
                            text: I18n.signup,
                            type: 'primary',
                            onPressed: () {
                              handleRegister();
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
                                MyRouteDelegate.of(context).push(
                                    AppRoutes.login,
                                    deletePreviousCount: 1);
                              },
                              child: Column(children: [
                                Text(I18n.goToLogin,
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
      ),
    );
  }
}
