import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/apis/auth_api.dart';

import '../../controllers/auth_controller.dart';

final authApi = AuthApi();

class LoginPageScaffold extends StatefulWidget {
  final Function(String? title, String? message)? onError;
  final Widget Function(
    TextEditingController accountController,
    TextEditingController passwordController,
    String? Function(String? value) validateUsername,
    String? Function(String? value) validatePassword,
    Function() handleLogin,
  ) child;
  const LoginPageScaffold({
    Key? key,
    this.onError,
    required this.child,
  }) : super(key: key);

  @override
  LoginPageScaffoldState createState() => LoginPageScaffoldState();
}

class LoginPageScaffoldState extends State<LoginPageScaffold> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入帳號';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    return null;
  }

  handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        var token = await authApi.login(
            username: accountController.text,
            password: passwordController.text);
        if (token == null) {
          if (widget.onError != null) {
            widget.onError!('登入錯誤', '帳號或密碼不正確');
          }
        } else {
          Get.find<AuthController>().setToken(token);
          MyRouteDelegate.of(context).popRoute();
        }
      } catch (error) {
        if (widget.onError != null) {
          widget.onError!('登入錯誤', '帳號或密碼不正確');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.child(accountController, passwordController,
          validateUsername, validatePassword, handleLogin),
    );
  }
}
