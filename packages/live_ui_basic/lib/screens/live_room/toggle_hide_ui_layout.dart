import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';

class ToggleHideUILayout extends StatelessWidget {
  final int pid;
  const ToggleHideUILayout({super.key, required this.pid});

  @override
  Widget build(BuildContext context) {
    final LiveRoomController liveRoomController =
        Get.find<LiveRoomController>(tag: pid.toString());
    return GestureDetector(
      onTap: () {
        if (liveRoomController.displayChatInput.value == false) {
          liveRoomController.toggleHideAllUI();
        }
      },
      child: Container(
        color: Colors.transparent, // Replace with your desired background color
      ),
    );
  }
}
