import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottom_navigator_controller.dart';

class MainNavigationProvider extends StatefulWidget {
  final String? defaultScreenKey;
  final Widget Function(String activeKey) child;

  const MainNavigationProvider({
    Key? key,
    required this.child,
    this.defaultScreenKey,
  }) : super(key: key);

  @override
  MainNavigationProviderState createState() => MainNavigationProviderState();
}

class MainNavigationProviderState extends State<MainNavigationProvider> {
  final bottomNavigatorController = Get.find<BottomNavigatorController>();

  @override
  void initState() {
    if (widget.defaultScreenKey != null) {
      bottomNavigatorController.changeKey(widget.defaultScreenKey!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var activeKey = bottomNavigatorController.activeKey.value;

      return widget.child(activeKey);
    });
  }
}
