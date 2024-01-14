import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';

Map<int, String> chargeTypeTexts = {
  1: '免費',
  2: '付費',
  3: '付費',
};

Map<int, int> chargeTypeBGColors = {
  1: 0xe6845fcf,
  2: 0xe65fcf95,
  3: 0xe65fcf95,
};

class RoomChargeType extends StatelessWidget {
  final int pid;

  const RoomChargeType({Key? key, required this.pid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveRoomController controller = Get.find(tag: pid.toString());

    return Obx(() => Container(
          height: 20,
          decoration: const BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3.3)),
          ),
          color: Color(
              chargeTypeBGColors[controller.liveRoomInfo.value?.chargeType] ??
                  0xe6845fcf),
          child: Center(
            child: Text(
                chargeTypeTexts[controller.liveRoomInfo.value?.chargeType] ??
                    '免費',
                style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ));
  }
}
