// RegisterPage , has button , click push to '/register'

import 'package:app_gp/widgets/custom_app_bar.dart';
import 'package:app_gp/widgets/login/forgot_password_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/showConfirmDialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';
import '../widgets/login/button.dart';

final logger = Logger();
final authApi = AuthApi();

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      return '账号为6-12位字母及数字';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    if (!RegExp(r'^[a-zA-Z0-9]{8,20}$').hasMatch(value)) {
      return '密码为8-20位字母及数字';
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
        ;
        // TODO: var invitationCode = Get.find<AppController>().invitationCode;
        var res = await authApi.register(
            uid: userController.info.value.uid,
            username: _accountController.text,
            password: _passwordController.text);
        logger.i('register success $res');

        if (res.code == '00') {
          userController.mutateAll();
          MyRouteDelegate.of(context).popRoute();
        } else {
          showConfirmDialog(
            context: context,
            title: '註冊錯誤',
            message: '帳號或密碼不正確 ${res.code}',
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
          message: '帳號或密碼不正確(-1)',
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
                      label: '帳號:',
                      controller: _accountController,
                      placeholderText: '請輸入帳號',
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '密碼:',
                      obscureText: true,
                      controller: _passwordController,
                      placeholderText: '請輸入密碼',
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '驗證密碼:',
                      obscureText: true,
                      controller: _confirmPasswordController,
                      placeholderText: '請輸入驗證密碼',
                      validator: _validateConfirmPassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: 360,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Button(
                        text: '註冊',
                        size: 'small',
                        onPressed: () {
                          _handleRegister(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Button(
                        text: '取消',
                        size: 'small',
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
                          child: Column(children: [
                            Text('前往登入', style: TextStyle(color: Colors.white)),
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
