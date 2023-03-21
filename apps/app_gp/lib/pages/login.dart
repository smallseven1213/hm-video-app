// LoginPage , has button , click push to '/register'

import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            MyRouteDelegate.of(context)
                .push('/register', deletePreviousCount: 1);
          },
          child: Text('Register'),
        ),
      ),
    );
  }
}
