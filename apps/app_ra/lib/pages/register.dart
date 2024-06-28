import 'package:app_ra/widgets/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/modules/register/register_scaffold.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool agreeToTerms = false; // 狀態管理變數，用於追蹤 checkbox 的狀態

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
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('本站含有成人內容，註冊前請確認已滿18歲',
                            maxLines: 2,
                            softWrap: true,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: '註冊',
                      onPressed: () {
                        if (agreeToTerms) {
                          handleRegister();
                        } else {
                          showConfirmDialog(
                            context: context,
                            title: '未滿18歲',
                            message: '您尚未滿18歲，無法註冊本站帳號',
                            showCancelButton: false,
                            onConfirm: () {},
                          );
                        }
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
      ),
    );
  }
}
