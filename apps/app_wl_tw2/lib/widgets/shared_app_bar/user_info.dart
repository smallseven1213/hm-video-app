import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/models/user_v2.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';
import 'package:shared/utils/intl_amount.dart';
import '../../localization/i18n.dart';

class UserInfo extends StatefulWidget {
  final UserV2 info;
  final bool isLoading;

  const UserInfo({Key? key, required this.info, required this.isLoading})
      : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    if (widget.isLoading) {
      _animationController.repeat();
    } else {
      _animationController.stop();
    }
  }

  @override
  void didUpdateWidget(UserInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              Get.find<UserController>().fetchUserInfoV2();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Total Balance:',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    if (widget.isLoading)
                      RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0)
                            .animate(_animationController),
                        child: const Image(
                          image: AssetImage('assets/images/reload_balance.png'),
                          fit: BoxFit.contain,
                          height: 13,
                        ),
                      )
                    else
                      const Image(
                        image: AssetImage('assets/images/reload_balance.png'),
                        fit: BoxFit.contain,
                        height: 13,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      intlAmount(widget.info.points, I18n.dollar),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
              onTap: () {
                final currentPath = MyRouteDelegate.of(context).currentPath;
                final bottomNavigatorController =
                    Get.find<BottomNavigatorController>();
                final currentTabActiveKey = bottomNavigatorController.activeKey;
                final isGameUesr = GetStorage().read('isGameUser');
                if ((currentTabActiveKey.value == "/game" &&
                        currentPath == "/home") ||
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
              child: const SizedBox(
                width: 40,
                child: Image(
                  image: AssetImage('assets/images/user_balance.png'),
                  fit: BoxFit.contain,
                  height: 35,
                ),
              ))
        ],
      ),
    );
  }
}
