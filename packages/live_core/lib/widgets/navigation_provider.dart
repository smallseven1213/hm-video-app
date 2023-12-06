import 'package:flutter/material.dart';
import 'package:live_core/controllers/navigation_controller.dart';
import 'package:get/get.dart';

import '../models/navigation.dart';

class NavigationProvider extends StatefulWidget {
  final Widget Function(List<Navigation> navigation) child;
  const NavigationProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationProvider> {
  final NavigationController _navigationController =
      Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(_navigationController.navigation));
  }
}
