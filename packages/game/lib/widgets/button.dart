import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class GameButton extends StatelessWidget {
  const GameButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        color: disabled ? gameLobbyButtonDisableColor : gamePrimaryButtonColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextButton(
        onPressed: disabled ? () => {} : onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: disabled
                ? gameLobbyButtonDisableTextColor
                : gamePrimaryButtonTextColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
