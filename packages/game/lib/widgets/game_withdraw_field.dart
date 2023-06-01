// GameWithDrawField是一個Stateless widget, 會有2個props為"name"以及"value"
// 會在畫面中出現左邊是name, 右邊為value的文字, 全是垂直置中

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/game_theme_config.dart';

class GameWithDrawField extends StatelessWidget {
  const GameWithDrawField({
    Key? key,
    this.name = '',
    required this.value,
    this.showClipboard = false,
  }) : super(key: key);

  final String name;
  final String value;
  final bool showClipboard;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (name != '') const SizedBox(width: 20),
          if (name != '')
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
          if (name != '') const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showClipboard)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '已複製',
                            style: TextStyle(color: gamePrimaryButtonTextColor),
                          ),
                          backgroundColor: gamePrimaryButtonColor,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.copy,
                      color: gameLobbyPrimaryTextColor,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
