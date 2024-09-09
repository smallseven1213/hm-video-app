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
      // 獲取 BottomNavigatorController
      final bottomNavigatorController = Get.find<BottomNavigatorController>();

      // 執行轉址邏輯
      MyRouteDelegate.of(context).pushAndRemoveUntil(
        AppRoutes.home,
        args: {'defaultScreenKey': '/game'},
      );
      bottomNavigatorController.changeKey('/game');

      // 發送事件
      eventBus.fireEvent("gotoDepositAfterLogin");
    });

    return const SizedBox();
  }
}
