import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/apis/auth_api.dart';

import '../../localization/shared_localization_delegate.dart';

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
  late SharedLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = SharedLocalizations.of(context)!;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return localizations.translate('please_enter_your_account');
    }

    if (!RegExp(r'^[a-zA-Z0-9]{6,12}$').hasMatch(value)) {
      return localizations
          .translate('account_must_be_6-12_alphanumeric_characters');
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return localizations.translate('please_enter_your_password');
    }
    if (!RegExp(r'^[a-zA-Z0-9]{8,20}$').hasMatch(value)) {
      return localizations
          .translate('password_must_be_8-20_alphanumeric_characters');
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return localizations.translate('please_enter_verification_password');
    }
    if (value != passwordController.text) {
      return localizations.translate('verification_password_does_not_match');
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
          widget.onError!(localizations.translate('registration_error'),
              localizations.translate('account_already_exists_pls_reenter'));
        } else {
          widget.onError!(localizations.translate('registration_error'),
              localizations.translate('incorrect_account_or_password'));
        }
      } on DioException catch (error) {
        if (error.response?.data['code'] == '40000') {
          widget.onError!(localizations.translate('registration_error'),
              localizations.translate('account_already_exists_pls_reenter'));
        } else {
          widget.onError!(localizations.translate('registration_error'),
              localizations.translate('incorrect_account_or_password'));
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
