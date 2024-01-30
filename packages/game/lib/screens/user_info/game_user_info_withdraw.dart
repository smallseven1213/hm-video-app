import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

import '../../localization/game_localization_delegate.dart';

class UserInfoWithdraw extends StatefulWidget {
  const UserInfoWithdraw({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  State<UserInfoWithdraw> createState() => _UserInfoWithdraw();
}

class _UserInfoWithdraw extends State<UserInfoWithdraw> {
  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      width: 62,
      height: 60,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "packages/game/assets/images/game_lobby/withdraw.webp",
              width: 28,
              height: 28,
            ),
            Text(
              localizations.translate('withdrawal'),
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
