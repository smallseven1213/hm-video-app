import 'package:flutter/material.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers/more.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers/resize.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers/sound.dart';

import '../../widgets/circle_button.dart';
import 'right_corner_controllers/gift.dart';

class RightCornerControllers extends StatelessWidget {
  const RightCornerControllers({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        More(),
        SizedBox(height: 15),
        Resize(),
        SizedBox(height: 15),
        Sound(),
        SizedBox(height: 20),
        GiftWidget(),
      ],
    );
  }
}
