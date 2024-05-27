import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import '../controllers/response_controller.dart';
import '../localization/shared_localization_delegate.dart';

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
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return Scaffold(
      body: showErrorMessage
          ? AlertDialog(
              title: Text(localizations.translate('duplicate_account_login')),
              content: Text(localizations
                  .translate('you_have_been_logged_out_please_log_in_again')),
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
                  child: Text(localizations.translate('confirm')),
                ),
              ],
            )
          : widget.child,
    );
  }
}
