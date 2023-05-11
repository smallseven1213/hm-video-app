// GameWithDrawField是一個Stateless widget, 會有2個props為"name"以及"value"
// 會在畫面中出現左邊是name, 右邊為value的文字, 全是垂直置中

import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class GameWithDrawField extends StatelessWidget {
  const GameWithDrawField({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              name,
              style: TextStyle(
                color: gameLobbyPrimaryTextColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
