import 'package:flutter/material.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:shared/models/hm_api_response_with_data.dart';

import '../apis/auth_api.dart';

class LiveScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;

  const LiveScaffold({
    super.key,
    this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  _LiveScaffoldState createState() => _LiveScaffoldState();
}

class _LiveScaffoldState extends State<LiveScaffold> {
  // 是否已經由登入伺服器驗證?的變數
  bool isLoading = true;
  bool isLogin = false;
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
    var response = await authApi.login(token);
    if (response.code == '200') {
      GetStorage().write('token', token);
      isLogin = true;
    } else {
      isLogin = false;
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (isLogin == false) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: widget.appBar,
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      // 其他 Scaffold 屬性...
    );
  }
}
