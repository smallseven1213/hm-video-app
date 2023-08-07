import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/route_controller.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final RouteController routeController = Get.find();

  @override
  void didPush(Route route, Route? previousRoute) {
    routeController.onPush(route.settings.name ?? '');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // routeController.onPop(route.settings.name ?? '');
  }
}
