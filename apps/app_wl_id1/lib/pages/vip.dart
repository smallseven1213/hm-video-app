import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用 WidgetsBinding 確保轉址在頁面構建後執行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bottomNavigatorController = Get.find<BottomNavigatorController>();
      MyRouteDelegate.of(context).pushAndRemoveUntil(
        AppRoutes.home,
        args: {'defaultScreenKey': '/game'},
      );
      bottomNavigatorController.changeKey('/game');
      eventBus.fireEvent("gotoDepositAfterLogin");
    });

    return const SizedBox();
  }
}
