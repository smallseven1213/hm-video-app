import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game/navigator/delegate.dart';
import 'package:game/controllers/game_response_controller.dart';
import 'package:game/enums/game_app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ErrorOverlayWidget extends StatefulWidget {
  final Widget child;
  const ErrorOverlayWidget({super.key, required this.child});
  @override
  _ErrorOverlayWidgetState createState() => _ErrorOverlayWidgetState();
}

class _ErrorOverlayWidgetState extends State<ErrorOverlayWidget> {
  final responseController = Get.find<GameApiResponseErrorCatchController>();

  @override
  void initState() {
    super.initState();
    responseController.responseStatus.listen((status) {
      if (status == 401 && !responseController.alertDialogShown.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          responseController.setAlertDialogShown(true);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('帳號重複登入'),
              content: const Text('你已被登出，請重新登入'),
              actions: [
                TextButton(
                  onPressed: () {
                    responseController.setAlertDialogShown(false);
                    MyRouteDelegate.of(context)
                        .push(GameAppRoutes.home.value, removeSamePath: true);
                  },
                  child: const Text('確認'),
                ),
              ],
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
    );
  }
}
