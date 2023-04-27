import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/response_controller.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ErrorOverlayWidget extends StatefulWidget {
  final Widget child;
  const ErrorOverlayWidget({super.key, required this.child});
  @override
  _ErrorOverlayWidgetState createState() => _ErrorOverlayWidgetState();
}

class _ErrorOverlayWidgetState extends State<ErrorOverlayWidget> {
  final responseController = Get.find<ResponseController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Obx(() {
          if (responseController.responseStatus.value == 401) {
            return AlertDialog(
              title: Text('Unauthorized'),
              content: Text('你已被登出，請重新登入'),
              actions: [
                TextButton(
                  onPressed: () {
                    responseController.updateResponseStatus(0);
                  },
                  child: Text('確認'),
                ),
              ],
            );
          }
          return widget.child;
        }),
      ),
    );
  }
}
