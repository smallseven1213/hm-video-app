import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:shared/navigator/delegate.dart';

import '../../enums/game_app_routes.dart';
import '../../localization/game_localization_delegate.dart';

class UserInfoWithdrawHistory extends StatefulWidget {
  const UserInfoWithdrawHistory({Key? key}) : super(key: key);

  @override
  State<UserInfoWithdrawHistory> createState() => _UserInfoWithdrawHistory();
}

class _UserInfoWithdrawHistory extends State<UserInfoWithdrawHistory> {
  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      width: 60,
      height: 60,
      child: InkWell(
        onTap: () {
          MyRouteDelegate.of(context).push(GameAppRoutes.withdrawRecord);
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
              localizations.translate('withdrawal_history'),
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
