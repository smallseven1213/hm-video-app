import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

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
    return SizedBox(
      width: 30,
      height: 60,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/img/game_lobby/deposit.webp",
              width: 28,
              height: 28,
            ),
            Text(
              '存款',
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
