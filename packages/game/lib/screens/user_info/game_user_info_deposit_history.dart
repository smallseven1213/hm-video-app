import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:shared/navigator/delegate.dart';

import '../../enums/game_app_routes.dart';
import '../../localization/game_localization_delegate.dart';

class UserInfoDepositHistory extends StatefulWidget {
  const UserInfoDepositHistory({Key? key}) : super(key: key);

  @override
  State<UserInfoDepositHistory> createState() => _UserInfoDepositHistory();
}

class _UserInfoDepositHistory extends State<UserInfoDepositHistory> {
  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      width: 60,
      height: 60,
      child: InkWell(
        onTap: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.depositRecord);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "packages/game/assets/images/game_lobby/withdraw-record.webp",
              width: 28,
              height: 28,
            ),
            Text(
              localizations.translate('deposit_history'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gameLobbyPrimaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
