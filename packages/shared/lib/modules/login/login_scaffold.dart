import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/apis/auth_api.dart';

final authApi = AuthApi();

class LoginPageScaffold extends StatefulWidget {
  final Widget forgetPasswordButton;
  final Function() showErrorDialog;
  final Widget Function(TextEditingController accountController,
      TextEditingController passwordController) child;
  const LoginPageScaffold({
    Key? key,
    required this.forgetPasswordButton,
    required this.showErrorDialog,
    required this.child,
  }) : super(key: key);

  @override
  LoginPageScaffoldState createState() => LoginPageScaffoldState();
}

class LoginPageScaffoldState extends State<LoginPageScaffold> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Form(
            key: _formKey,
            child: widget.child(_accountController, _passwordController),
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
