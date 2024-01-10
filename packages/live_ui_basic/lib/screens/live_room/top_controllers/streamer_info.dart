import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/widgets/follow_live_check_provider.dart';
import 'package:live_core/widgets/live_image.dart';

class StreamerInfo extends StatelessWidget {
  final int pid;
  final int hid;
  const StreamerInfo({Key? key, required this.pid, required this.hid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveRoomController =
        Get.find<LiveRoomController>(tag: pid.toString());

    return Obx(() {
      var roomInfo = liveRoomController.liveRoomInfo.value;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black,
        ),
        width: 135,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink,
              ),
              child: roomInfo?.playerCover != null
                  ? ClipOval(
                      child: LiveImage(
                        base64Url: roomInfo!.playerCover!,
                        width: 30,
                        height: 30,
                      ),
                    )
                  : Container(),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                // vertical center
                mainAxisAlignment: MainAxisAlignment.center,
                // horizal left
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomInfo?.nickname ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // 水平置左
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        liveRoomController.displayUserCount.value > 1000
                            ? 'packages/live_ui_basic/assets/images/ic_hot.webp'
                            : 'packages/live_ui_basic/assets/images/ic_view.webp',
                        width: 8,
                        height: 8,
                      ),
                      Text(
                        liveRoomController.displayUserCount.value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            FollowLiveCheckProvider(
                pid: pid,
                hid: hid,
                streamerNickname: roomInfo?.nickname ?? "",
                child: (isFollowed) => Container(
                      width: 30,
                      height: 30,
                      child: Center(
                        child: Container(
                          width: 25,
                          height: 25,
                          child: Image(
                            image: AssetImage(isFollowed
                                ? "packages/live_ui_basic/assets/images/room_is_followed_icon.webp"
                                : "packages/live_ui_basic/assets/images/room_is_not_followed_icon.webp"),
                          ),
                        ),
                      ),
                    )),
          ],
        ),
      );
    });
  }
}
