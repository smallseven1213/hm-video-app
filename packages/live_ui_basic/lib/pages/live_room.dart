import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/commands_controller.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/widgets/room_payment_check.dart';
import 'package:live_ui_basic/libs/showLiveDialog.dart';
import 'package:live_ui_basic/screens/live_room/center_gift_screen.dart';
import 'package:live_ui_basic/screens/live_room/chatroom_layout.dart';
import 'package:live_ui_basic/screens/live_room/player_layout.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers.dart';
import 'package:live_ui_basic/screens/live_room/top_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/live_room/command_controller.dart';
import '../widgets/live_button.dart';
import '../screens/live_room/room_charge_type.dart';
import '../widgets/live_room_skelton.dart';
import '../widgets/room_payment_button.dart';

final liveApi = LiveApi();

class LiveRoomPage extends StatefulWidget {
  final int pid;
  const LiveRoomPage({Key? key, required this.pid}) : super(key: key);

  @override
  _LiveRoomPageState createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  bool _isControllerInitialized = false;
  late final LiveRoomController controller;
  late final CommandsController commandsController;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  Future<void> initializeController() async {
    controller = await Get.putAsync<LiveRoomController>(() async {
      var liveRoomController = LiveRoomController(widget.pid);
      await liveRoomController.fetchData();
      return liveRoomController;
    }, tag: widget.pid.toString());

    Get.delete<CommandsController>();

    if (controller.hasError.value) {
      showLiveDialog(
        context,
        title: '直播間沒開',
        content: const Center(
          child: Text('直播間沒開',
              style: TextStyle(color: Colors.white, fontSize: 11)),
        ),
        actions: [
          LiveButton(
              text: '確定',
              type: ButtonType.primary,
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              })
        ],
      );
    }

    commandsController = Get.put(CommandsController());

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

    setState(() {
      _isControllerInitialized = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    commandsController.dispose();
    Get.delete<LiveRoomController>(tag: widget.pid.toString());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      return LiveRoomSkeleton(
        pid: widget.pid,
      );
    }
    return Obx(() {
      if (controller.liveRoom.value != null) {
        return Scaffold(
          body: Stack(
            children: [
              if (controller.displayAmount.value > 0 ||
                  controller.liveRoom.value!.pullUrlDecode == null)
                Container(color: Colors.black),
              if (controller.displayAmount.value <= 0 &&
                  controller.liveRoom.value!.pullUrlDecode != null)
                PlayerLayout(
                    pid: widget.pid,
                    uri: Uri.parse(
                        '${controller.liveRoom.value!.pullUrlDecode!}&token=${GetStorage().read('live-token')}')),
              Positioned(
                top: MediaQuery.of(context).padding.top + 50,
                left: 0,
                child: TopControllers(
                  key: ValueKey(controller.liveRoomInfo.value?.streamerId),
                  hid: controller.liveRoomInfo.value?.streamerId ?? 0,
                  pid: widget.pid,
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
                  right: 10,
                  child: RoomChargeType(pid: widget.pid)),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 25,
                  right: 10,
                  child: RightCornerControllers(pid: widget.pid)),
              Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  left: 7,
                  child: ChatroomLayout(
                    key: ValueKey(controller.liveRoomInfo.value?.streamerId),
                    token: controller.liveRoom.value!.chattoken,
                  )),
              Positioned(
                  top: MediaQuery.of(context).padding.top + 110,
                  right: 10,
                  child: const CommandController()),
              RoomPaymentCheck(
                  pid: widget.pid,
                  child: (bool hasPermission) {
                    if (!hasPermission) {
                      return Positioned(
                          bottom: MediaQuery.of(context).padding.bottom + 20,
                          left: 40,
                          right: 40,
                          child: RoomPaymentButton(
                            key: ValueKey(widget.pid),
                            pid: widget.pid,
                          ));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
              const CenterGiftScreen()
            ],
          ),
        );
      } else {
        return LiveRoomSkeleton(
          pid: widget.pid,
        );
      }
    });
  }
}
