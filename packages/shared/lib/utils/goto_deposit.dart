import 'package:flutter/material.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:get/get.dart';

import '../controllers/bottom_navigator_controller.dart';
import '../enums/app_routes.dart';
import '../navigator/delegate.dart';
import 'event_bus.dart';

void gotoDeposit(BuildContext context) async {
  final bottomNavigatorController = Get.find<BottomNavigatorController>();

  bottomNavigatorController.changeKey('/game');

  eventBus.fireEvent("gotoDepositAfterLogin");
}


// MyRouteDelegate.of(context).push(
//     //     GameAppRoutes.depositList,
//     //   );