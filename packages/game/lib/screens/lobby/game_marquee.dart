import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/widgets/marquee.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameMarquee extends StatefulWidget {
  final List data;

  const GameMarquee({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<GameMarquee> createState() => _GameMarqueeState();
}

class _GameMarqueeState extends State<GameMarquee> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GameMarqueeWidget(
          icon: Icon(
            Icons.volume_down,
            size: 25,
            color: Colors.white,
          ),
          style: TextStyle(color: Colors.white),
          // text: widget.data.map((e) => e['title']).join('    '),
          text: '給我一億元，我給你全世界'),
    );
  }
}
