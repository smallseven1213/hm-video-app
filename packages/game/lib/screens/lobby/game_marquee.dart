import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/widgets/marquee.dart';
import 'package:get/get.dart';

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
    print('widget.data: ${widget.data}');
    return SizedBox(
      width: double.infinity,
      child: Marquee(
        icon: Icon(
          Icons.volume_down,
          size: 25,
          color: gameLobbyIconColor,
        ),
        width: Get.width - 40,
        style: TextStyle(color: gameLobbyPrimaryTextColor),
        text: widget.data.map((e) => e['title']).join('    '),
      ),
    );
  }
}
