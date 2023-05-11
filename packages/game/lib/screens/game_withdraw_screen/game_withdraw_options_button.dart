import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class GameWithdrawalOptionsButton extends StatelessWidget {
  const GameWithdrawalOptionsButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isActive,
  }) : super(key: key);

  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isActive ? gamePrimaryButtonColor : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        side: BorderSide(
            color: isActive ? gamePrimaryButtonColor : Colors.white24),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isActive
                ? gamePrimaryButtonTextColor
                : gameSecondButtonTextColor,
            fontSize: 12),
      ),
    );
  }
}
