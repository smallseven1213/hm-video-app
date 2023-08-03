import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class GameMaintenance extends StatelessWidget {
  const GameMaintenance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: gameLobbyBgColor,
      child: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'packages/game/assets/images/maintenance.webp',
                width: 86,
                height: 100,
              ),
              const SizedBox(height: 10),
              Text(
                '目前系統維護中',
                style: TextStyle(
                  color: gameLobbyAppBarTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '預計維護時間 08:00-10:00',
                style: TextStyle(
                  color: Color(0xff979797),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '請稍後再試，造成不便請見諒',
                style: TextStyle(
                  color: Color(0xff979797),
                  fontSize: 13,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
