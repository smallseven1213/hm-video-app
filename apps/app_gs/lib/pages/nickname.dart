// NicknamePage , has button , click push to '/info'
import 'package:app_gs/widgets/button.dart';
import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/showConfirmDialog.dart';
import '../widgets/auth_text_field.dart';

final logger = Logger();
final authApi = AuthApi();
final userApi = UserApi();

class NicknamePage extends StatefulWidget {
  const NicknamePage({Key? key}) : super(key: key);

  @override
  NicknamePageState createState() => NicknamePageState();
}

class NicknamePageState extends State<NicknamePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  UserController get userController => Get.find<UserController>();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '請輸入暱稱';
    }
    // 可在此添加其他驗證邏輯
    return null;
  }

  void _handleLogin(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await userApi.updateNickname(_accountController.text);
        userController.updateNickname(_accountController.text);
        MyRouteDelegate.of(context).popRoute();
      } catch (error) {
        showConfirmDialog(
          context: context,
          title: '修改錯誤',
          message: '',
          showCancelButton: false,
          onConfirm: () {
            MyRouteDelegate.of(context).popRoute();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '修改暱稱',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    AuthTextField(
                      label: '新暱稱',
                      controller: _accountController,
                      placeholderText: '請輸入暱稱',
                      validator: _validateUsername,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: 200,
                child: Button(
                  text: '設置完成',
                  onPressed: () => _handleLogin(context),
                  size: 'small',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
