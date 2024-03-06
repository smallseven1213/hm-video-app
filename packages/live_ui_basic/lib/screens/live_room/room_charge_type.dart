import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';

import '../../localization/live_localization_delegate.dart';

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
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    Map<int, String> chargeTypeTexts = {
      1: localizations.translate('free'),
      2: localizations.translate('paid'),
      3: localizations.translate('paid'),
    };

    return Obx(() => Container(
          height: 20,
          // padding 10
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Color(
                chargeTypeBGColors[controller.liveRoomInfo.value?.chargeType] ??
                    0xe6845fcf),
            borderRadius: const BorderRadius.all(Radius.circular(3.3)),
          ),
          child: Center(
            child: Text(
                chargeTypeTexts[controller.liveRoomInfo.value?.chargeType] ??
                    localizations.translate('free'),
                style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ));
  }
}
