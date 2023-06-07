// RegisterPage , has button , click push to '/register'

import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:app_gs/widgets/login/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

final logger = Logger();

final authApi = AuthApi();

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserController userController = Get.find<UserController>();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入帳號';
    }

    if (!RegExp(r'^[a-zA-Z0-9]{6,12}$').hasMatch(value)) {
      return '帳號為6-12位字母及數字';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    if (!RegExp(r'^[a-zA-Z0-9]{8,20}$').hasMatch(value)) {
      return '密碼為8-20位字母及數字';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入驗證密碼';
    }
    if (value != _passwordController.text) {
      return '驗證密碼不一致';
    }
    // 可在此添加其他驗證邏輯
    return null;
  }

  void _handleRegister(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // TODO: var invitationCode = Get.find<AppController>().invitationCode;
        var res = await authApi.register(
            uid: userController.info.value.uid,
            username: _accountController.text,
            password: _passwordController.text);
        logger.i('register success $res');

        if (res.code == '00') {
          userController.fetchUserInfo();
          MyRouteDelegate.of(context).popRoute();
        } else {
          showConfirmDialog(
            context: context,
            title: '註冊錯誤',
            message: '帳號或密碼不正確',
            showCancelButton: false,
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        }
      } catch (error) {
        showConfirmDialog(
          context: context,
          title: '註冊錯誤',
          message: '帳號或密碼不正確',
          showCancelButton: false,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '註冊',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    AuthTextField(
                      label: '帳　　號',
                      controller: _accountController,
                      placeholderText: '請輸入帳號',
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '密　　碼',
                      obscureText: true,
                      controller: _passwordController,
                      placeholderText: '請輸入密碼',
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '驗證密碼',
                      obscureText: true,
                      controller: _confirmPasswordController,
                      placeholderText: '請輸入驗證密碼',
                      validator: _validateConfirmPassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Button(
                        text: '註冊',
                        onPressed: () {
                          _handleRegister(context);
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
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        InkWell(
                          onTap: () {
                            MyRouteDelegate.of(context).push(
                                AppRoutes.login.value,
                                deletePreviousCount: 1);
                          },
                          child: const Column(children: [
                            Text('前往登入',
                                style: TextStyle(
                                  color: Color(0xFF00B2FF),
                                  decoration: TextDecoration.underline,
                                )),
                          ]),
                        )
                      ]),
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
