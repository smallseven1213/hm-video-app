import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

Widget buildChip({
  required String label,
  required bool selected,
  required VoidCallback onSelected,
  Widget? avatar,
}) {
  return GestureDetector(
    onTap: onSelected,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: selected ? gameLobbyTabActiveBgColor : gameLobbyTabBgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avatar != null) ...[
            avatar,
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color:
                  selected ? gamePrimaryButtonColor : gameLobbyPrimaryTextColor,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
