import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_ui_basic/screens/live_room/chatroom_layout.dart';
import 'package:live_ui_basic/screens/live_room/player_layout.dart';
import 'package:live_ui_basic/screens/live_room/rank.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers.dart';
import 'package:live_ui_basic/screens/live_room/top_controllers.dart';
import 'package:video_player/video_player.dart';

class LiveRoomPage extends StatefulWidget {
  final int pid;
  const LiveRoomPage({Key? key, required this.pid}) : super(key: key);

  @override
  _LiveRoomPageState createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  late final LiveRoomController controller;

  @override
  void initState() {
    super.initState();
    controller =
        Get.put(LiveRoomController(widget.pid), tag: widget.pid.toString());

    // 監聽hasError的變化
    controller.hasError.listen((hasError) {
      if (hasError) {
        // 顯示對話框
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('錯誤'),
              content: const Text('沒有此聊天室'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 關閉對話框
                    Navigator.of(context).pop(); // 返回上一頁
                  },
                  child: const Text('確定'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose(); // 適當地清理controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.liveRoom.value.pullUrlDecode == null) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            PlayerLayout(
              uri: Uri.parse(controller.liveRoom.value.pullUrlDecode!),
            ),
            // Positioned(
            //     top: MediaQuery.of(context).padding.top + 50,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 7),
            //       child: TopControllers(),
            //     )),
            // Positioned(
            //     top: MediaQuery.of(context).padding.top + 120,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 7),
            //       child: Rank(),
            //     )),
            // Positioned(
            //     top: 10,
            //     right: 10,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 7),
            //       child: RightCornerControllers(),
            //     )),
            Positioned(
                bottom: 0,
                left: 0,
                child: ChatroomLayout(
                  token: controller.liveRoom.value.chattoken,
                ))
          ],
        ),
      );
    });
  }
}
