import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/apis/auth_api.dart';

final authApi = AuthApi();

class RegisterPageScaffold extends StatefulWidget {
  final Function(String? title, String? message)? onError;
  final Widget Function(
    TextEditingController accountController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    String? Function(String? value) validateUsername,
    String? Function(String? value) validatePassword,
    String? Function(String? value) validateConfirmPassword,
    Function() handleRegister,
  ) child;
  const RegisterPageScaffold({
    Key? key,
    this.onError,
    required this.child,
  }) : super(key: key);

  @override
  RegisterPageScaffoldState createState() => RegisterPageScaffoldState();
}

class RegisterPageScaffoldState extends State<RegisterPageScaffold> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final UserController userController = Get.find<UserController>();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入帳號';
    }

    if (!RegExp(r'^[a-zA-Z0-9]{6,12}$').hasMatch(value)) {
      return '帳號為6-12位字母及數字';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入密碼';
    }
    if (!RegExp(r'^[a-zA-Z0-9]{8,20}$').hasMatch(value)) {
      return '密碼為8-20位字母及數字';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入驗證密碼';
    }
    if (value != passwordController.text) {
      return '驗證密碼不一致';
    }

    return null;
  }

  handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        var res = await authApi.register(
            uid: userController.info.value.uid,
            username: accountController.text,
            password: passwordController.text);

        if (res.code == '00') {
          userController.fetchUserInfo();
          // ignore: use_build_context_synchronously
          MyRouteDelegate.of(context).popRoute();
        } else if (res.code == '40000') {
          widget.onError!('註冊錯誤', '帳號已存在，請重新輸入帳號。');
        } else {
          widget.onError!('註冊錯誤', '帳號或密碼不正確');
        }
      } on DioException catch (error) {
        if (error.response?.data['code'] == '40000') {
          widget.onError!('註冊錯誤', '帳號已存在，請重新輸入帳號。');
        } else {
          widget.onError!('註冊錯誤', '帳號或密碼不正確');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.child(
        accountController,
        passwordController,
        confirmPasswordController,
        validateUsername,
        validatePassword,
        validateConfirmPassword,
        handleRegister,
      ),
    );
  }
}
