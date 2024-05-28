import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ui_controller.dart';

class UIBottomSafeArea extends StatelessWidget {
  final Widget child;

  const UIBottomSafeArea({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiController = Get.find<UIController>();
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      bottom: uiController.isIphoneSafari.value ? false : true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: uiController.isIphoneSafari.value
              ? paddingBottom + (uiController.isIphoneSafari.value ? 20 : 0)
              : 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
          ],
        ),
      ),
    );
  }
}
