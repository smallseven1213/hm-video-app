// UpdatePasswordPage , has button , click push to '/register'

import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/showConfirmDialog.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';

final logger = Logger();

final userApi = UserApi();

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  UpdatePasswordPageState createState() => UpdatePasswordPageState();
}

class UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _originPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserController userController = Get.find<UserController>();

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
      return '驗證密碼不一緻';
    }
    return null;
  }

  void _handleUpdatePassword(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        var res = await userApi.updatePassword(
            _originPasswordController.text, _passwordController.text);
        logger.i('register success $res');

        if (res.code == '00') {
          userController.fetchUserInfo();
          MyRouteDelegate.of(context).popRoute();
        } else {
          showConfirmDialog(
            context: context,
            title: '錯誤',
            message: '密碼不正確',
            showCancelButton: false,
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        }
      } catch (error) {
        showConfirmDialog(
          context: context,
          title: '錯誤',
          message: '密碼不正確',
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
        title: '修改密碼',
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
                      label: '原密碼',
                      controller: _originPasswordController,
                      placeholderText: '請輸入帳號',
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      label: '新密碼',
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
                        text: '確認修改',
                        size: 'medium',
                        type: 'secondary',
                        onPressed: () {
                          _handleUpdatePassword(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
