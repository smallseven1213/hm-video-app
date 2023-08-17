import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/apis/auth_api.dart';

final authApi = AuthApi();

class LoginPageScaffold extends StatefulWidget {
  final TextEditingController accountController;
  final TextEditingController passwordController;
  final Widget forgetPasswordButton;
  final Function() showErrorDialog;
  final Widget accountTextField;
  final Widget passwordTextField;
  const LoginPageScaffold({
    Key? key,
    required this.accountController,
    required this.passwordController,
    required this.forgetPasswordButton,
    required this.showErrorDialog,
    required this.accountTextField,
    required this.passwordTextField,
  }) : super(key: key);

  @override
  LoginPageScaffoldState createState() => LoginPageScaffoldState();
}

class LoginPageScaffoldState extends State<LoginPageScaffold> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleLogin(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        var token = await authApi.login(
            username: widget.accountController.text,
            password: widget.passwordController.text);
        if (token == null) {
          widget.showErrorDialog();
        } else {
          // Get.find<AuthController>().setToken(token);
          MyRouteDelegate.of(context).popRoute();
        }
      } catch (error) {
        widget.showErrorDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Form(
            key: _formKey,
            child: Column(
              children: [
                widget.accountTextField,
                widget.passwordTextField,
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _handleLogin(context);
                  },
                  child: const Text('登入'),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      MyRouteDelegate.of(context)
                          .push(AppRoutes.register, deletePreviousCount: 1);
                    },
                    child: const Column(children: [
                      Text('還沒有帳號',
                          style: TextStyle(
                            color: Color(0xFF00B2FF),
                            decoration: TextDecoration.underline,
                          )),
                    ]),
                  ),
                  widget.forgetPasswordButton,
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
