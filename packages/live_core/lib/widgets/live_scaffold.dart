import 'package:flutter/material.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../apis/auth_api.dart';
import '../controllers/gifts_controller.dart';
import '../controllers/live_list_controller.dart';
import '../controllers/live_search_controller.dart';
import '../controllers/live_search_history_controller.dart';
import '../controllers/live_system_controller.dart';
import '../controllers/live_user_controller.dart';
import '../controllers/user_follows_controller.dart';
import 'loading.dart';

class LiveScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const LiveScaffold({
    super.key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  LiveScaffoldState createState() => LiveScaffoldState();
}

class LiveScaffoldState extends State<LiveScaffold> {
  // 是否已經由登入伺服器驗證?的變數
  bool isLoading = true;
  bool isLogin = false;
  final authController = Get.find<AuthController>();
  final liveSystemController = Get.put(LiveSystemController());

  @override
  void initState() {
    super.initState();

    if (authController.token.value.isNotEmpty) {
      _loginAndSaveToken(authController.token.value);
    }

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
    if (response.code == 200) {
      GetStorage().write('live-token', response.data["token"]);
      GetStorage()
          .write('recharge_platform', response.data["recharge_platform"]);
      liveSystemController.liveApiHost.value = response.data["apiHost"];
      isLogin = true;
      Get.replace<LiveListController>(LiveListController());
      Get.put(LiveUserController());
      Get.put(UserFollowsController());
      Get.put(GiftsController());
    } else {
      isLogin = false;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: SafeArea(
        child: (isLoading || !isLogin)
            ? const SizedBox()
            : widget.body ?? const SizedBox(),
      ),
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      // 其他 Scaffold 屬性...
    );
  }
}
