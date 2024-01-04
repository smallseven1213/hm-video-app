import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/models/room_rank.dart';
import 'package:live_core/widgets/rank_provider.dart';

import 'top_controllers/rank_data.dart';
import 'top_controllers/rank_list.dart';
import 'top_controllers/streamer_info.dart';

class TopControllers extends StatelessWidget {
  final int pid;
  final int hid;
  const TopControllers({Key? key, required this.pid, required this.hid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RankProvider(
      pid: pid,
      child: (RoomRank? roomRank) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          // align left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Room Info
                  StreamerInfo(pid: pid, hid: hid),
                  Expanded(
                    flex: 1,
                    child: RankList(
                      roomRank: roomRank,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      final liveRoomController =
                          Get.find<LiveRoomController>(tag: pid.toString());
                      liveRoomController.exitRoom();
                    },
                    child: const SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: Image(
                            image: AssetImage(
                                "packages/live_ui_basic/assets/images/room_close.webp"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // width 7
                  const SizedBox(width: 7),
                ],
              ),
            ),
            // height 10
            const SizedBox(height: 10),
            RankData(
              roomRank: roomRank,
            )
          ],
        ),
      ),
    );
  }
}
