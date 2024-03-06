import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:shimmer/shimmer.dart';

class LiveRoomSkeleton extends StatelessWidget {
  final int pid;
  const LiveRoomSkeleton({Key? key, required this.pid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildShimmerEffect(context),
          Positioned(
            top: MediaQuery.of(context).padding.top + 50,
            left: 0,
            child: Column(
              // align left
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
