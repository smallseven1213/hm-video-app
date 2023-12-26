import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_ui_basic/screens/live_room/chatroom_layout.dart';
import 'package:live_ui_basic/screens/live_room/player_layout.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers.dart';
import 'package:live_ui_basic/screens/live_room/top_controllers.dart';

import '../screens/live_room/command_controller.dart';
import '../widgets/room_payment_button.dart';

final liveApi = LiveApi();

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

    // 用pid去LiveListController撈資料並傳入LiveRoomController
    final liveListController = Get.find<LiveListController>();
    final room = liveListController.getRoomById(widget.pid);
    if (room != null) {
      controller.liveRoomInfo.value = room;
    }

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
            Obx(() {
              if (controller.liveRoom.value.amount > 0) {
                return Container(
                  color: Colors.black,
                );
              }
              return PlayerLayout(
                uri: Uri.parse(controller.liveRoom.value.pullUrlDecode!),
              );
            }),
            Positioned(
                top: MediaQuery.of(context).padding.top + 50,
                left: 0,
                child: TopControllers(
                  pid: widget.pid,
                )),
            // Positioned(
            //     top: MediaQuery.of(context).padding.top + 120,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 7),
            //       child: Rank(),
            //     )),
            const Positioned(
                bottom: 25, right: 10, child: RightCornerControllers()),
            Positioned(
                bottom: 0,
                left: 7,
                child: ChatroomLayout(
                  token: controller.liveRoom.value.chattoken,
                )),
            Positioned(
                top: MediaQuery.of(context).padding.top + 100,
                right: 10,
                child: CommandController()),
            Positioned(
                bottom: 20,
                left: 40,
                right: 40,
                child: RoomPaymentButton(
                  onTap: () async {
                    if (controller.liveRoomInfo.value?.chargeType == 3) {
                      // 計時付費
                      var result = await liveApi.buyWatch(widget.pid);
                      if (result.data == true) {
                        // enterroom again
                        controller.fetchData();
                      } else {
                        // show alert
                      }
                    } else if (controller.liveRoomInfo.value?.chargeType == 2) {
                      // 付費直播
                      var result = await liveApi.buyTicket(widget.pid);
                      if (result.data == true) {
                        controller.fetchData();
                      } else {
                        // show alert
                      }
                    }
                  },
                  pid: widget.pid,
                ))
          ],
        ),
      );
    });
  }
}
