import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/widgets/chatroom_provider.dart';
import 'package:live_core/widgets/room_payment_check.dart';
import 'package:live_ui_basic/libs/show_live_dialog.dart';
import 'package:live_ui_basic/localization/live_localization_delegate.dart';
import 'package:live_ui_basic/screens/live_room/center_gift_screen.dart';
import 'package:live_ui_basic/screens/live_room/chatroom_layout.dart';
import 'package:live_ui_basic/screens/live_room/player_layout.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers.dart';
import 'package:live_ui_basic/screens/live_room/top_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/live_room/command_controller.dart';
import '../screens/live_room/toggle_hide_ui_layout.dart';
import '../widgets/live_button.dart';
import '../screens/live_room/room_charge_type.dart';
import '../widgets/live_room_skelton.dart';
import '../widgets/room_payment_button.dart';

final liveApi = LiveApi();

class LiveRoomPage extends StatefulWidget {
  final int pid;
  const LiveRoomPage({Key? key, required this.pid}) : super(key: key);

  @override
  LiveRoomPageState createState() => LiveRoomPageState();
}

class LiveRoomPageState extends State<LiveRoomPage> {
  bool _isControllerInitialized = false;
  late final LiveRoomController controller;
  late final LiveLocalizations localizations;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = LiveLocalizations.of(context)!;
  }

  Future<void> initializeController() async {
    controller = await Get.putAsync<LiveRoomController>(() async {
      var liveRoomController = LiveRoomController(widget.pid);
      await liveRoomController.fetchData();
      return liveRoomController;
    }, tag: widget.pid.toString());

    if (controller.hasError.value && mounted) {
      showLiveDialog(
        context,
        title: localizations.translate('live_room_is_not_open'),
        content: Center(
          child: Text(localizations.translate('live_room_is_not_open'),
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ),
        actions: [
          LiveButton(
              text: localizations.translate('confirm'),
              type: ButtonType.primary,
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              })
        ],
      );
    }

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
              title: Text(localizations.translate('error')),
              content: Text(localizations.translate('no_such_chat_room')),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 關閉對話框
                    Navigator.of(context).pop(); // 返回上一頁
                  },
                  child: Text(localizations.translate('confirm')),
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
            body: ChatroomProvider(
          chatToken: controller.liveRoom.value!.chattoken,
          child: Stack(
            children: [
              Container(color: Colors.black),
              if (controller.currentVideoPullUrl.value != "" &&
                  controller.currentVideoPullUrl.value.isNotEmpty)
                PlayerLayout(
                    key: ValueKey(controller.currentVideoPullUrl.value),
                    pid: widget.pid,
                    uri: Uri.parse(
                        '${controller.currentVideoPullUrl.value}&token=${GetStorage().read('live-token')}')),
              ToggleHideUILayout(pid: widget.pid),
              if (controller.hideAllUI.value == false) ...[
                if (controller.liveRoomInfo.value?.streamerId != null)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 20,
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
                      pid: widget.pid,
                      token: controller.liveRoom.value!.chattoken,
                    )),
                Positioned(
                    top: MediaQuery.of(context).padding.top + 110,
                    right: 10,
                    child: CommandController(pid: widget.pid)),
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
              ]
            ],
          ),
        ));
      } else {
        return LiveRoomSkeleton(
          pid: widget.pid,
        );
      }
    });
  }
}
