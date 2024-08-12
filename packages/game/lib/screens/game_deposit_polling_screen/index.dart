import 'package:flutter/material.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_deposit_list_screen/tips.dart';
import 'package:game/screens/game_deposit_polling_screen/amount_items.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_deposit.dart';
import 'package:game/screens/user_info/game_user_info_deposit_history.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:game/screens/user_info/game_user_info_withdraw.dart';
import 'package:game/widgets/pay_switch_button.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/game_localization_delegate.dart';

class GameDepositPolling extends StatefulWidget {
  const GameDepositPolling({Key? key}) : super(key: key);

  @override
  GameDepositPollingState createState() => GameDepositPollingState();
}

class GameDepositPollingState extends State<GameDepositPolling> {
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: gameLobbyBgColor,
        appBar: AppBar(
          toolbarHeight: 48,
          centerTitle: true,
          title: Text(
            localizations.translate('deposit'),
            style: TextStyle(
              color: gameLobbyAppBarTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: gameLobbyBgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: gameLobbyBgColor,
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Column(
                    children: [
                      PaySwitchButton(
                        // 存款
                        leftChild: UserInfoDeposit(
                          onTap: () {
                            MyRouteDelegate.of(context).push(
                              gameConfigController.depositRoute.value,
                              removeSamePath: true,
                            );
                          },
                        ),
                        // 提現
                        rightChild: UserInfoWithdraw(
                          onTap: () {
                            MyRouteDelegate.of(context).push(
                                GameAppRoutes.withdraw,
                                removeSamePath: true);
                          },
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: GameUserInfo(
                          child: Wrap(
                            spacing: 20,
                            children: [
                              UserInfoDepositHistory(),
                              UserInfoService(),
                            ],
                          ),
                        ),
                      ),
                      const AmountItems(),
                      const SizedBox(height: 36),
                      const Tips(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
