import 'package:flutter/material.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers/more.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers/resize.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers/sound.dart';

import 'right_corner_controllers/gift.dart';
import 'right_corner_controllers/languages.dart';

class RightCornerControllers extends StatelessWidget {
  final int pid;
  const RightCornerControllers({Key? key, required this.pid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const More(),
        const SizedBox(height: 15),
        Languages(pid: pid),
        const SizedBox(height: 15),
        const Resize(),
        const SizedBox(height: 15),
        Sound(pid: pid),
        const SizedBox(height: 20),
        GiftWidget(pid: pid),
      ],
    );
  }
}
