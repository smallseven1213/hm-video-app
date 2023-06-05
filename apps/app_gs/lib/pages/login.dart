// LoginPage , has button , click push to '/register'

import 'package:app_gs/widgets/button.dart';
import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:app_gs/widgets/login/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/showConfirmDialog.dart';
import '../widgets/auth_text_field.dart';

final logger = Logger();
final authApi = AuthApi();

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final field1Key = GlobalKey<FormFieldState>();
  final field2Key = GlobalKey<FormFieldState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入帳號';
    }
    // 可在此添加其他驗證邏輯
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    // 可在此添加其他驗證邏輯
    return null;
  }

  void _handleLogin(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        var token = await authApi.login(
            username: _accountController.text,
            password: _passwordController.text);
        if (token == null) {
          showConfirmDialog(
            context: context,
            title: '登入錯誤',
            message: '帳號或密碼不正確',
            showCancelButton: false,
            onConfirm: () {
              // Navigator.of(context).pop();
            },
          );
        } else {
          Get.find<AuthController>().setToken(token);
          MyRouteDelegate.of(context).popRoute();
        }
      } catch (error) {
        showConfirmDialog(
          context: context,
          title: '登入錯誤',
          message: '帳號或密碼不正確',
          showCancelButton: false,
          onConfirm: () {
            // Navigator.of(context).pop();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '登入',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Center(
              //   child: InkWell(
              //     onTap: () {
              //       MyRouteDelegate.of(context)
              //           .push('/register', deletePreviousCount: 1);
              //     },
              //     child: Column(children: [
              //       Text('註冊', style: TextStyle(color: Colors.white)),
              //     ]),
              //   ),
              // ),
              const SizedBox(height: 80),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    AuthTextField(
                      label: '帳號',
                      controller: _accountController,
                      placeholderText: '請輸入帳號',
                      onChanged: (value) {
                        field1Key.currentState!.validate();
                      },
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '密碼',
                      controller: _passwordController,
                      placeholderText: '請輸入密碼',
                      obscureText: true,
                      onChanged: (value) {
                        field2Key.currentState!.validate();
                      },
                      validator: _validatePassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              SizedBox(
                width: 200,
                child: Button(
                  text: '登入',
                  onPressed: () => _handleLogin(context),
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
                              AppRoutes.register.value,
                              deletePreviousCount: 1);
                        },
                        child: Column(children: const [
                          Text('還沒有帳號',
                              style: TextStyle(
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
      ),
    );
  }
}
