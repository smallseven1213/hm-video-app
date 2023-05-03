import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class UserInfoWithdraw extends StatefulWidget {
  const UserInfoWithdraw({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  State<UserInfoWithdraw> createState() => _UserInfoWithdraw();
}

class _UserInfoWithdraw extends State<UserInfoWithdraw> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 60,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/img/game_lobby/withdraw.webp",
              width: 28,
              height: 28,
            ),
            Text(
              '提現',
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
