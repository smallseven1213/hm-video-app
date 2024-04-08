import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_navigator_controller.dart';
import 'event_bus.dart';

void gotoDeposit(BuildContext context) async {
  final bottomNavigatorController = Get.find<BottomNavigatorController>();

  bottomNavigatorController.changeKey('/game');

  eventBus.fireEvent("gotoDepositAfterLogin");
}
