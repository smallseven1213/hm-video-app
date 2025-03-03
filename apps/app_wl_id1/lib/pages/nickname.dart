// NicknamePage , has button , click push to '/info'
import 'package:app_wl_id1/localization/i18n.dart';
import 'package:app_wl_id1/widgets/button.dart';
import 'package:app_wl_id1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../utils/show_confirm_dialog.dart';
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
      return I18n.pleaseEnterNickname;
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
          title: I18n.editError,
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
      appBar: CustomAppBar(
        title: I18n.modifyNickname,
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
                      label: I18n.newNickname,
                      controller: _accountController,
                      placeholderText: I18n.pleaseEnterNickname,
                      validator: _validateUsername,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: 200,
                child: Button(
                  text: I18n.setupCompleted,
                  onPressed: () => _handleLogin(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
