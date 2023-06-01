import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class GameLabel extends StatefulWidget {
  const GameLabel({
    Key? key,
    required this.label,
    required this.text,
    this.hasIcon,
  }) : super(key: key);

  final String label;
  final String text;
  final Icon? hasIcon;

  @override
  _GameLabelState createState() => _GameLabelState();
}

class _GameLabelState extends State<GameLabel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.hasIcon != null)
              Container(
                margin: const EdgeInsets.only(right: 2),
                child: widget.hasIcon,
              ),
            SizedBox(
              width: widget.hasIcon != null ? 70 : 100,
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Color(0xff979797),
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              widget.text,
              style: TextStyle(color: gameLobbyPrimaryTextColor, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
