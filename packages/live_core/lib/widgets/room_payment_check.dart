import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/live_room_controller.dart';

class RoomPaymentCheck extends StatelessWidget {
  final Widget child;
  final int pid;

  const RoomPaymentCheck({Key? key, required this.child, required this.pid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveRoomController liveroomController = Get.find(tag: pid.toString());

    if (liveroomController.liveRoom.value == null ||
        liveroomController.liveRoomInfo.value?.chargeType == 1 ||
        liveroomController.displayAmount.value <= 0) {
      return const SizedBox.shrink();
    } else {
      return child;
    }
  }
}
