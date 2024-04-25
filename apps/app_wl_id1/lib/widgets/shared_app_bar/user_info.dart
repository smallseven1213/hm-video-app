import 'package:flutter/material.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';

class UserInfo extends StatelessWidget {
  final User info;

  const UserInfo({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final currentPath = MyRouteDelegate.of(context).currentPath;
        final bottomNavigatorController = Get.find<BottomNavigatorController>();
        final currentTabActiveKey = bottomNavigatorController.activeKey;
        final isGameUesr = GetStorage().read('isGameUser');
        if ((currentTabActiveKey.value == "/game" && currentPath == "/home") ||
            isGameUesr == true) {
          GamePlatformConfigController gameConfigController =
              Get.find<GamePlatformConfigController>();
          final route = gameConfigController.switchPaymentPage.value ==
                  switchPaymentPageType['list']
              ? GameAppRoutes.depositList
              : GameAppRoutes.depositPolling;
          MyRouteDelegate.of(context).push(route);
        } else {
          bottomNavigatorController.changeKey('/game');
          eventBus.fireEvent("gotoDepositAfterLogin");
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                const Text(
                  'Total Balance:',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                Text(
                  info.depositedAmount ?? "0",
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ],
            ),
            const Image(
              image: AssetImage('assets/images/user_balance.png'),
              fit: BoxFit.contain,
              height: 35,
            )
          ],
        ),
      ),
    );
  }
}
