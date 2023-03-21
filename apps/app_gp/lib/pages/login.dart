// LoginPage , has button , click push to '/register'

import 'package:app_gp/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';

import '../widgets/auth_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '登入',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              MyRouteDelegate.of(context)
                  .push('/register', deletePreviousCount: 1);
            },
            child: Column(children: [
              AuthTextField(
                label: '帳號',
                inputController: TextEditingController(),
                placeholderText: '請輸入帳號',
              ),
              AuthTextField(
                label: '密碼',
                inputController: TextEditingController(),
                placeholderText: '請輸入密碼',
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
