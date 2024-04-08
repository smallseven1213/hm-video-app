import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../controllers/bottom_navigator_controller.dart';
import 'event_bus.dart';

void gotoDeposit(BuildContext context) async {
  var rechargePlatform = GetStorage().read('recharge_platform');
  // 1:遊戲錢包、2:影音錢包
  if (rechargePlatform == 1) {
    final bottomNavigatorController = Get.find<BottomNavigatorController>();
    bottomNavigatorController.changeKey('/game');
    eventBus.fireEvent("gotoDepositAfterLogin");
  } else {
    MyRouteDelegate.of(context).push(AppRoutes.coin);
  }
}
