import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../controllers/room_rank_controller.dart';

class RankProvider extends StatefulWidget {
  final int pid;
  final Widget child;

  const RankProvider({Key? key, required this.pid, required this.child})
      : super(key: key);

  @override
  RankProviderState createState() => RankProviderState();
}

class RankProviderState extends State<RankProvider> {
  @override
  void initState() {
    super.initState();
    Get.put<RoomRankController>(RoomRankController(widget.pid),
        tag: widget.pid.toString());
  }

  @override
  void dispose() {
    // 删除控制器
    Get.delete<RoomRankController>(tag: widget.pid.toString());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
