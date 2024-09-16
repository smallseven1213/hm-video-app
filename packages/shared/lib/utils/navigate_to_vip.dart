import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';

class VipNavigationHandler {
  static void navigateToPage(
    BuildContext context,
    bool? useGameDeposit,
  ) {
    if (useGameDeposit == true) {
      final bottomNavigatorController = Get.find<BottomNavigatorController>();
      MyRouteDelegate.of(context).push(
        AppRoutes.home,
        args: {'defaultScreenKey': '/game'},
        removeSamePath: true,
      );
      bottomNavigatorController.changeKey('/game');
      eventBus.fireEvent("gotoDepositAfterLogin");
    } else {
      MyRouteDelegate.of(context).push(AppRoutes.vip);
    }
  }
}
