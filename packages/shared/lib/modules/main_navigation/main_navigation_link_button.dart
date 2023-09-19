import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottom_navigator_controller.dart';

class MainNavigationLinkButton extends StatefulWidget {
  final String screenKey;
  final Widget child;

  const MainNavigationLinkButton({
    Key? key,
    required this.screenKey,
    required this.child,
  }) : super(key: key);

  @override
  MainNavigationLinkButtonState createState() =>
      MainNavigationLinkButtonState();
}

class MainNavigationLinkButtonState extends State<MainNavigationLinkButton> {
  final bottomNavigatorController = Get.find<BottomNavigatorController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bottomNavigatorController.changeKey(widget.screenKey);
      },
      child: widget.child,
    );
  }
}
