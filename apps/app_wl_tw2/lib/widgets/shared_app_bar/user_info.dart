import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/models/user.dart';
import 'package:shared/models/user_v2.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';
import 'package:shared/utils/intl_amount.dart';
import '../../localization/i18n.dart';

class UserInfo extends StatefulWidget {
  final User info;

  const UserInfo({Key? key, required this.info}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Get.find<UserController>().fetchUserInfo();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '當前餘額',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xffb2bac5),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/images/reload_balance.png'),
                      fit: BoxFit.contain,
                      height: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.info.points ?? '0',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                        onTap: () {
                          final currentPath =
                              MyRouteDelegate.of(context).currentPath;
                          final bottomNavigatorController =
                              Get.find<BottomNavigatorController>();
                          final currentTabActiveKey =
                              bottomNavigatorController.activeKey;
                          final isGameUesr = GetStorage().read('isGameUser');
                          if ((currentTabActiveKey.value == "/game" &&
                                  currentPath == "/home") ||
                              isGameUesr == true) {
                            GamePlatformConfigController gameConfigController =
                                Get.find<GamePlatformConfigController>();
                            final route =
                                gameConfigController.switchPaymentPage.value ==
                                        switchPaymentPageType['list']
                                    ? GameAppRoutes.depositList
                                    : GameAppRoutes.depositPolling;
                            MyRouteDelegate.of(context).push(route);
                          } else {
                            bottomNavigatorController.changeKey('/game');
                            eventBus.fireEvent("gotoDepositAfterLogin");
                          }
                        },
                        child: const SizedBox(
                          width: 15,
                          height: 15,
                          child: Image(
                            image: AssetImage('assets/images/user_balance.png'),
                            fit: BoxFit.contain,
                            height: 15,
                            width: 15,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
