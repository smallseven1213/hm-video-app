import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:game/controllers/game_response_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../localization/game_localization_delegate.dart';

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
              title: Text(
                  GameLocalizations.of(context)!.translate('duplicate_login')),
              content: Text(GameLocalizations.of(context)!
                  .translate('you_have_been_logged_out_please_log_in_again')),
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
