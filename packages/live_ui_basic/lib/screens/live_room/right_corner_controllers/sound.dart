import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';

class Sound extends StatelessWidget {
  final int pid;
  const Sound({
    super.key,
    required this.pid,
  });

  @override
  Widget build(BuildContext context) {
    final LiveRoomController liveRoomController =
        Get.find<LiveRoomController>(tag: pid.toString());
    return InkWell(
      onTap: () {
        if (liveRoomController.isMute.value) {
          liveRoomController.isMute.value = false;
        } else {
          liveRoomController.isMute.value = true;
        }
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/sound_button.webp',
          width: 33,
          height: 33),
    );
  }
}
