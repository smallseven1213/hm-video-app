import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:logger/logger.dart';
import 'package:marquee/marquee.dart';

final logger = Logger();

class GameMarqueeWidget extends StatefulWidget {
  final double iconWidth;
  final double width;
  final String text;
  final TextStyle? style;
  final Icon? icon;

  const GameMarqueeWidget({
    Key? key,
    this.iconWidth = 30,
    this.width = 100,
    this.style,
    this.icon,
    required this.text,
  }) : super(key: key);

  @override
  GameMarqueeWidgetState createState() => GameMarqueeWidgetState();
}

class GameMarqueeWidgetState extends State<GameMarqueeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.text.isEmpty
          ? []
          : [
              SizedBox(
                width: widget.iconWidth,
                child: const Icon(
                  Icons.volume_down,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: widget.width - widget.iconWidth,
                height: 30,
                child: Marquee(
                  key: widget.key,
                  text: widget.text,
                  style: widget.style ??
                      TextStyle(fontSize: 12, color: gameLobbyPrimaryTextColor),
                ),
              )
            ],
    );
  }
}
