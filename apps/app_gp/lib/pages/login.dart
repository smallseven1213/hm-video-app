// LoginPage , has button , click push to '/register'

import 'package:app_gp/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/navigator/delegate.dart';

import '../widgets/auth_text_field.dart';
import '../widgets/login/button.dart';

final logger = Logger();
final authApi = AuthApi();

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        var res = authApi.login(
            username: _accountController.text,
            password: _passwordController.text);
        logger.i('login success $res');
      } catch (error) {
        logger.i('login error $error');
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
                      label: '帳號:',
                      controller: _accountController,
                      placeholderText: '請輸入帳號',
                      // onChanged: (value) {
                      //   _formKey.currentState!.validate();
                      // },
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '密碼:',
                      controller: _passwordController,
                      placeholderText: '請輸入密碼',
                      // onChanged: (value) {
                      //   _validatePassword(value);
                      // },
                      validator: _validatePassword,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              LoginButton(
                  text: '登入',
                  onPressed: () {
                    _handleLogin();
                  }),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          MyRouteDelegate.of(context)
                              .push('/register', deletePreviousCount: 1);
                        },
                        child: Column(children: [
                          Text('還沒有帳號', style: TextStyle(color: Colors.white)),
                        ]),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 12, // 設置分隔線高度
                        width: 1, // 設置分隔線寬度
                        color: Colors.grey, // 設置分隔線顏色
                      ),
                      InkWell(
                        onTap: () {
                          MyRouteDelegate.of(context)
                              .push('/register', deletePreviousCount: 1);
                        },
                        child: Column(children: [
                          Text('忘記密碼', style: TextStyle(color: Colors.white)),
                        ]),
                      ),
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
