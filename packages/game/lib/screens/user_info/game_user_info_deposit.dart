import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

import '../../localization/game_localization_delegate.dart';

class UserInfoDeposit extends StatefulWidget {
  const UserInfoDeposit({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  State<UserInfoDeposit> createState() => _UserInfoDeposit();
}

class _UserInfoDeposit extends State<UserInfoDeposit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;
    return SizedBox(
      width: 60,
      height: 60,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "packages/game/assets/images/game_lobby/deposit.webp",
              width: 28,
              height: 28,
            ),
            Text(
              localizations.translate('deposit'),
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
