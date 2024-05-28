import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/apis/auth_api.dart';

import '../../controllers/auth_controller.dart';
import '../../localization/shared_localization_delegate.dart';

final authApi = AuthApi();

class ErrorMessageProps {
  final String account;
  final String password;
  ErrorMessageProps({
    required this.account,
    required this.password,
  });
}

class LoginPageScaffold extends StatefulWidget {
  final Function(String? title, String? message)? onError;
  final ErrorMessageProps? errorMessage;
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
    this.errorMessage,
    required this.child,
  }) : super(key: key);

  @override
  LoginPageScaffoldState createState() => LoginPageScaffoldState();
}

class LoginPageScaffoldState extends State<LoginPageScaffold> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late SharedLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = SharedLocalizations.of(context)!;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return widget.errorMessage?.account ??
          localizations.translate('please_enter_your_account');
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return widget.errorMessage?.password ??
          localizations.translate('please_enter_your_password');
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
            widget.onError!(localizations.translate('login_error'),
                localizations.translate('incorrect_account_or_password'));
          }
        } else {
          Get.find<AuthController>().setToken(token);
          MyRouteDelegate.of(context).popRoute();
        }
      } catch (error) {
        if (widget.onError != null) {
          widget.onError!(localizations.translate('login_error'),
              localizations.translate('incorrect_account_or_password'));
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
