import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:restart_app/restart_app.dart';
import '../controllers/response_controller.dart';
import '../enums/app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ErrorOverlayWidget extends StatefulWidget {
  final Widget child;
  const ErrorOverlayWidget({super.key, required this.child});
  @override
  ErrorOverlayWidgetState createState() => ErrorOverlayWidgetState();
}

class ErrorOverlayWidgetState extends State<ErrorOverlayWidget> {
  final responseController = Get.find<ApiResponseErrorCatchController>();
  bool showErrorMessage = false;

  @override
  void initState() {
    super.initState();
    responseController.apiResponse.listen((response) {
      if (response.status == 401 &&
          response.message == 'Unauthorized' &&
          !responseController.alertDialogShown.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            showErrorMessage = true;
            responseController.setAlertDialogShown(true);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showErrorMessage
          ? AlertDialog(
              title: const Text('帳號重複登入'),
              content: const Text('你已被登出，請重新登入'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      showErrorMessage = false;
                    });
                    // MyRouteDelegate.of(context).pushAndRemoveUntil(
                    //     AppRoutes.splash,
                    //     hasTransition: false);

                    Restart.restartApp();
                  },
                  child: const Text('確認'),
                ),
              ],
            )
          : widget.child,
    );
  }
}
