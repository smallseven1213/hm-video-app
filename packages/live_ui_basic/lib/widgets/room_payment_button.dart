import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';

class RoomPaymentButton extends StatelessWidget {
  final int pid;
  final VoidCallback? onTap;

  const RoomPaymentButton({super.key, required this.pid, this.onTap});

  @override
  Widget build(BuildContext context) {
    final LiveRoomController liveroomController = Get.find(tag: pid.toString());
    return Obx(() {
      if (liveroomController.liveRoomInfo.value?.chargeType == 1 ||
          liveroomController.liveRoom.value.amount > 0) {
        return Container();
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 46.0,
            decoration: BoxDecoration(
              color: Color(0xFFae57ff),
              borderRadius: BorderRadius.circular(23.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "進入付費直播",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 14),
                Image.asset(
                  "packages/live_ui_basic/assets/images/rank_diamond.webp",
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 5),
                Text(liveroomController.liveRoom.value.amount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        );
      }
    });
  }
}
