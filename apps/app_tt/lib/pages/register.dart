// RegisterPage , has button , click push to '/register'

import 'package:app_tt/config/colors.dart';
import 'package:app_tt/widgets/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/register/register_scaffold.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../localization/i18n.dart';
import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(
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
                      I18n.accountPasswordLogin,
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
                        label: I18n.account,
                        controller: accountController,
                        placeholderText: I18n.pleaseEnterYourAccountNumber,
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: I18n.register,
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
                                MyRouteDelegate.of(context).push(
                                    AppRoutes.login,
                                    deletePreviousCount: 1);
                              },
                              child: Column(children: [
                                Text(
                                  I18n.accountPasswordLogin,
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
