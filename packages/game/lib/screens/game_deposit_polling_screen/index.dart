import 'package:flutter/material.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_deposit_polling_screen/amount_items.dart';
import 'package:game/screens/game_deposit_list_screen/tips.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/i18n.dart';

class GameDepositPolling extends StatefulWidget {
  const GameDepositPolling({Key? key}) : super(key: key);

  @override
  GameDepositPollingState createState() => GameDepositPollingState();
}

class GameDepositPollingState extends State<GameDepositPolling> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: gameLobbyBgColor,
        appBar: AppBar(
          toolbarHeight: 48,
          centerTitle: true,
          title: Text(
            I18n.deposit,
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
          actions: [
            TextButton(
              onPressed: () {
                MyRouteDelegate.of(context).push(GameAppRoutes.depositRecord);
              },
              child: Text(
                I18n.depositHistory,
                style: TextStyle(
                  color: gameLobbyAppBarTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: gameLobbyBgColor,
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: GameUserInfo(
                          child: UserInfoService(),
                        ),
                      ),
                      AmountItems(),
                      SizedBox(height: 36),
                      Tips(),
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
