import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/widgets/live_image.dart';

class StreamerInfo extends StatelessWidget {
  final int pid;
  const StreamerInfo({Key? key, required this.pid}) : super(key: key);

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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    roomInfo?.chargeAmount ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              child: Center(
                child: Container(
                  width: 25,
                  height: 25,
                  child: Image(
                    image: AssetImage(
                        "packages/live_ui_basic/assets/images/room_add_icon.webp"),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
