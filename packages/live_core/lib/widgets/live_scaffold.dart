import 'package:flutter/material.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../apis/auth_api.dart';
import '../controllers/gifts_controller.dart';
import '../controllers/live_list_controller.dart';
import '../controllers/live_system_controller.dart';
import '../controllers/live_user_controller.dart';
import '../controllers/user_follows_controller.dart';

// create a response.code map to error message Map<String, String>
const Map<int, String> errorMap = {
  400: 'account_or_password_error',
  401: 'please_login_first',
  409: 'conflict',
};

class LiveScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? loadingWidget;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final Function({String? errorMessage})? onError;

  const LiveScaffold({
    super.key,
    this.body,
    this.appBar,
    this.loadingWidget,
    this.floatingActionButton,
    this.backgroundColor,
    this.onError,
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
      liveSystemController.liveWsHost.value = response.data["wsHost"];

      isLogin = true;
      Get.replace<LiveListController>(LiveListController());
      Get.put(LiveUserController());
      Get.put(UserFollowsController());
      Get.put(GiftsController());
    } else {
      isLogin = false;
      if (response.code == 401 ||
          response.code == 409 ||
          response.code == 400) {
        if (context.mounted) {
          widget.onError?.call(
            errorMessage: errorMap[response.code],
          );
        }

        // Dialog
        // showLiveDialog(
        //   context,
        //   title: localizations.translate('not_enough_diamonds'),
        //   content: Center(
        //     child: Text(
        //         localizations
        //             .translate('insufficient_diamonds_please_recharge'),
        //         style: const TextStyle(color: Colors.white, fontSize: 11)),
        //   ),
        //   actions: [
        //     LiveButton(
        //         text: localizations.translate('cancel'),
        //         type: ButtonType.secondary,
        //         onTap: () {
        //           Navigator.of(context).pop();
        //         }),
        //     LiveButton(
        //         text: localizations.translate('confirm'),
        //         type: ButtonType.primary,
        //         onTap: () {
        //           Navigator.of(context).pop();
        //           Navigator.of(context).pop();
        //           Navigator.of(context).pop();
        //           gotoDeposit(context);
        //         })
        //   ],
        // );
      }
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: widget.appBar,
          body: (isLoading || !isLogin)
              ? widget.loadingWidget ?? const SizedBox()
              : widget.body ?? const SizedBox(),
          backgroundColor: widget.backgroundColor,
          floatingActionButton: widget.floatingActionButton,
          // 其他 Scaffold 屬性...
        ),
      ),
    );
  }
}
