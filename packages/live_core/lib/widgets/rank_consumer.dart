import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/room_rank_controller.dart';
import '../models/room_rank.dart';

class RankConsumer extends StatelessWidget {
  final int pid;
  final Widget Function(RoomRank? roomRank) child;

  const RankConsumer({Key? key, required this.pid, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用 Get.find() 查找相应的 RoomRankController
    final RoomRankController rankController =
        Get.find<RoomRankController>(tag: pid.toString());

    // 使用 Obx 监听 RoomRankController 中 roomRank 的变化
    return Obx(() => child(rankController.roomRank.value));
  }
}
