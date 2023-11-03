import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:game/controllers/game_response_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../localization/game_localization_deletate.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ErrorOverlayWidget extends StatefulWidget {
  final Widget child;
  const ErrorOverlayWidget({super.key, required this.child});
  @override
  ErrorOverlayWidgetState createState() => ErrorOverlayWidgetState();
}

class ErrorOverlayWidgetState extends State<ErrorOverlayWidget> {
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
                        .push(AppRoutes.home, removeSamePath: true);
                  },
                  child: Text(
                    GameLocalizations.of(context)!.translate('confirm'),
                  ),
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
