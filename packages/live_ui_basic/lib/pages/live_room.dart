import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/commands_controller.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_ui_basic/screens/live_room/chatroom_layout.dart';
import 'package:live_ui_basic/screens/live_room/player_layout.dart';
import 'package:live_ui_basic/screens/live_room/right_corner_controllers.dart';
import 'package:live_ui_basic/screens/live_room/top_controllers.dart';

import '../libs/showLiveDialog.dart';
import '../screens/live_room/command_controller.dart';
import '../widgets/live_button.dart';
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
      print(controller.liveRoom.value);
      if (controller.liveRoom.value != null) {
        return Scaffold(
          body: Stack(
            children: [
              if (controller.liveRoom.value!.amount > 0 ||
                  controller.liveRoom.value!.pullUrlDecode == null)
                Container(color: Colors.black),
              if (controller.liveRoom.value!.amount <= 0 &&
                  controller.liveRoom.value!.pullUrlDecode != null)
                PlayerLayout(
                    uri: Uri.parse(controller.liveRoom.value!.pullUrlDecode!)),
              Positioned(
                top: MediaQuery.of(context).padding.top + 50,
                left: 0,
                child: TopControllers(
                  hid: controller.liveRoomInfo.value?.streamerId ?? 0,
                  pid: widget.pid,
                ),
              ),
              const Positioned(
                  bottom: 25, right: 10, child: RightCornerControllers()),
              Positioned(
                  bottom: 0,
                  left: 7,
                  child: ChatroomLayout(
                    token: controller.liveRoom.value!.chattoken,
                  )),
              Positioned(
                  top: MediaQuery.of(context).padding.top + 100,
                  right: 10,
                  child: const CommandController()),
              Positioned(
                  bottom: 20,
                  left: 40,
                  right: 40,
                  child: RoomPaymentButton(
                    onTap: () async {
                      var price = controller.liveRoom.value!.amount;
                      var userAmount = Get.find<LiveUserController>().getAmount;
                      if (userAmount < price) {
                        showLiveDialog(
                          context,
                          title: '鑽石不足',
                          content: const Center(
                            child: Text('鑽石不足，請前往充值',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ),
                          actions: [
                            LiveButton(
                                text: '取消',
                                type: ButtonType.secondary,
                                onTap: () {
                                  Navigator.of(context).pop();
                                }),
                            LiveButton(
                                text: '確定',
                                type: ButtonType.primary,
                                onTap: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      } else {
                        if (controller.liveRoomInfo.value?.chargeType == 3) {
                          // 計時付費
                          var result = await liveApi.buyWatch(widget.pid);
                          if (result.data == true) {
                            controller.fetchData();
                          } else {
                            // show alert
                          }
                        } else if (controller.liveRoomInfo.value?.chargeType ==
                            2) {
                          // 付費直播
                          var result = await liveApi.buyTicket(widget.pid);
                          if (result.data == true) {
                            controller.fetchData();
                          } else {
                            // show alert
                          }
                        }
                      }
                    },
                    pid: widget.pid,
                  )),
            ],
          ),
        );
      } else {
        return LiveRoomSkeleton(
          pid: widget.pid,
        );
      }
    });

    // if (!_isControllerInitialized) {
    //   return CircularProgressIndicator(); // or some placeholder widget
    // }
    // return Scaffold(
    //   body: Stack(
    //     children: controller.liveRoom.value != null
    //         ? [
    //             Obx(() {
    //               if (controller.liveRoom.value!.amount > 0 ||
    //                   controller.liveRoom.value!.pullUrlDecode == null) {
    //                 return Container(
    //                   color: Colors.black,
    //                 );
    //               }
    //               String url = Uri.decodeFull(
    //                   controller.liveRoom.value!.pullUrlDecode!.trim());
    //               Uri parsedUri = Uri.parse(url);
    //               return PlayerLayout(uri: parsedUri);
    //             }),
    //             Positioned(
    //                 top: MediaQuery.of(context).padding.top + 50,
    //                 left: 0,
    //                 child: TopControllers(
    //                   hid: controller.liveRoomInfo.value?.hid ?? 0,
    //                   pid: widget.pid,
    //                 )),
    //             // Positioned(
    //             //     top: MediaQuery.of(context).padding.top + 120,
    //             //     child: Padding(
    //             //       padding: const EdgeInsets.symmetric(horizontal: 7),
    //             //       child: Rank(),
    //             //     )),
    //             const Positioned(
    //                 bottom: 25, right: 10, child: RightCornerControllers()),
    //             // Obx(() => Positioned(
    //             //     bottom: 0,
    //             //     left: 7,
    //             //     child: controller.liveRoom.value.chattoken.isNotEmpty
    // ? ChatroomLayout(
    //     token: controller.liveRoom.value.chattoken,
    //   )
    //             //         : Container())),
    //             Obx(() {
    //               print(controller.liveRoom.value);
    //               return Positioned(
    //                   bottom: 0,
    //                   left: 7,
    //                   child: Container(
    //                     child: Text(controller.liveRoom.value!.chattoken),
    //                   ));
    //             }),
    //             Positioned(
    //                 top: MediaQuery.of(context).padding.top + 100,
    //                 right: 10,
    //                 child: CommandController()),
    //             Positioned(
    //                 bottom: 20,
    //                 left: 40,
    //                 right: 40,
    // child: RoomPaymentButton(
    //   onTap: () async {
    //     var price = controller.liveRoom.value!.amount;
    //     var userAmount =
    //         Get.find<LiveUserController>().getAmount;
    //     if (userAmount < price) {
    //       showLiveDialog(
    //         context,
    //         title: '鑽石不足',
    //         content: const Center(
    //           child: Text('鑽石不足，請前往充值',
    //               style: TextStyle(
    //                   color: Colors.white, fontSize: 11)),
    //         ),
    //         actions: [
    //           LiveButton(
    //               text: '取消',
    //               type: ButtonType.secondary,
    //               onTap: () {
    //                 Navigator.of(context).pop();
    //               }),
    //           LiveButton(
    //               text: '確定',
    //               type: ButtonType.primary,
    //               onTap: () {
    //                 Navigator.of(context).pop();
    //               })
    //         ],
    //       );
    //     } else {
    //       if (controller.liveRoomInfo.value?.chargeType == 3) {
    //         // 計時付費
    //         var result = await liveApi.buyWatch(widget.pid);
    //         if (result.data == true) {
    //           controller.fetchData();
    //         } else {
    //           // show alert
    //         }
    //       } else if (controller
    //               .liveRoomInfo.value?.chargeType ==
    //           2) {
    //         // 付費直播
    //         var result = await liveApi.buyTicket(widget.pid);
    //         if (result.data == true) {
    //           controller.fetchData();
    //         } else {
    //           // show alert
    //         }
    //       }
    //     }
    //   },
    //   pid: widget.pid,
    // ))
    //           ]
    //         : [],
    //   ),
    // );
  }
}
