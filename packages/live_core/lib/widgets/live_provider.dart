import 'package:flutter/material.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../apis/auth_api.dart';

class LiveProvider extends StatefulWidget {
  final Widget? child;

  const LiveProvider({super.key, this.child});

  @override
  _LiveProviderState createState() => _LiveProviderState();
}

class _LiveProviderState extends State<LiveProvider> {
  // final LocalStorage storage = new LocalStorage('live_token');

  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // if (widget.token != null) {
    //   _loginAndSaveToken(widget.token);
    // }

    // listen for AuthController token changes, if changes then login
    ever(authController.token, (token) {
      if (token.isNotEmpty) {
        _loginAndSaveToken(token);
      }
    });
  }

  Future<void> _loginAndSaveToken(String token) async {
    final authApi = AuthApi();
    final liveToken = await authApi.login(token);
    // await storage.setItem('live_token', liveToken);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}
