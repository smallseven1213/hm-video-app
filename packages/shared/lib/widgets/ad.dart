import 'package:flutter/material.dart';
import 'package:shared/widgets/splash.dart';

import '../navigator/delegate.dart';
import 'test.dart';

class Ad extends StatelessWidget {
  const Ad({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              MyRouteDelegate.of(context).pushAndRemoveUntil('/home');
              // MyRouteDelegate.of(context).pushAndRemoveUntil((context) {
              //   return TestPage();
              // });
            },
            child: const Text('go to home')),
      ),
    );
  }
}
