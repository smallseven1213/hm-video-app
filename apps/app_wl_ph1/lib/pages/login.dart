import 'package:app_wl_ph1/localization/i18n.dart';
// LoginPage , has button , click push to '/register'

import 'package:app_wl_ph1/widgets/button.dart';
import 'package:app_wl_ph1/widgets/custom_app_bar.dart';
import 'package:app_wl_ph1/widgets/login/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/login/login_scaffold.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: CustomAppBar(title: I18n.login),
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
                    validatePassword, handleLogin) =>
                SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
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
                          controller: passwordController,
                          placeholderText: I18n.pleaseEnterYourPassword,
                          obscureText: true,
                          validator: validatePassword,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 200,
                    child: Button(
                      text: I18n.login,
                      onPressed: () => handleLogin(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              MyRouteDelegate.of(context).push(
                                  AppRoutes.register,
                                  deletePreviousCount: 1);
                            },
                            child: Column(children: [
                              Text(I18n.noAccountYet,
                                  style: const TextStyle(
                                    color: Color(0xFF00B2FF),
                                    decoration: TextDecoration.underline,
                                  )),
                            ]),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 12, // 設置分隔線高度
                            width: 1, // 設置分隔線寬度
                            color: Colors.grey, // 設置分隔線顏色
                          ),
                          const ForgotPasswordButton()
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
