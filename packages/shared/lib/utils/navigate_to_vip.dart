import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';

class NavigateToVip {
  static void navigateToVipPage(BuildContext context) {
    final bottomNavigatorController = Get.find<BottomNavigatorController>();

    MyRouteDelegate.of(context).pushAndRemoveUntil(
      AppRoutes.home,
      args: {'defaultScreenKey': '/game'},
    );

    bottomNavigatorController.changeKey('/game');

    eventBus.fireEvent("gotoDepositAfterLogin");
  }
}
