import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/models/command.dart';
import 'package:live_core/widgets/room_payment_check.dart';

import '../../libs/showLiveDialog.dart';
import '../../localization/live_localization_delegate.dart';
import '../../widgets/live_button.dart';
import 'right_corner_controllers/user_diamonds.dart';

final liveApi = LiveApi();

class CommandController extends StatelessWidget {
  final int pid;
  const CommandController({Key? key, required this.pid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RoomPaymentCheck(
        pid: pid,
        child: (bool hasPermission) {
          if (hasPermission) {
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Commands(pid: pid);
                  },
                );
              },
              child: Image.asset(
                  'packages/live_ui_basic/assets/images/ic_list_c.webp',
                  width: 33,
                  height: 33),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}

class Commands extends StatelessWidget {
  final int pid;
  const Commands({Key? key, required this.pid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveRoomController liveroomController = Get.find(tag: pid.toString());
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Container(
      height: 366,
      padding: const EdgeInsets.all(18),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.translate('command_list'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'packages/live_ui_basic/assets/images/close_gifts.webp',
                  width: 8,
                  height: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const UserDiamonds(),
          const SizedBox(height: 15),
          Expanded(
            child: Obx(
              () {
                var commands = liveroomController.liveRoom.value?.commands;
                if (commands == null) {
                  return Container();
                }
                return ListView.builder(
                  itemCount: (commands.length + 1) ~/ 2, // 修改这里
                  itemBuilder: (context, index) {
                    var startIndex = index * 2;
                    var itemsCount = commands.length;
                    var endIndex = startIndex + 1 < itemsCount
                        ? startIndex + 1
                        : startIndex; // 处理最后一个元素
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CommandItem(
                              command: commands[startIndex],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: endIndex > startIndex // 检查是否有第二个元素
                                ? CommandItem(
                                    command: commands[endIndex],
                                  )
                                : Container(), // 如果没有第二个元素，则展示空容器
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CommandItem extends StatelessWidget {
  final Command command;

  const CommandItem({Key? key, required this.command}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool arrowSend = true;
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    void showToast() {
      FToast fToast = FToast();
      fToast.init(context);

      Widget toast = Container(
        height: 30,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.7),
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            localizations.translate('send_successfully'),
            style: const TextStyle(color: Colors.white, fontSize: 12.7),
          ),
        ),
      );

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.CENTER,
        toastDuration: Duration(seconds: 2),
      );
    }

    return InkWell(
      onTap: () async {
        if (arrowSend) {
          arrowSend = false;

          try {
            var price = double.parse(command.price);
            var userAmount = Get.find<LiveUserController>().getAmount;
            if (userAmount < price) {
              showLiveDialog(
                context,
                title: localizations.translate('not_enough_diamonds'),
                content: Center(
                  child: Text(
                      localizations
                          .translate('insufficient_diamonds_please_recharge'),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 11)),
                ),
                actions: [
                  LiveButton(
                      text: localizations.translate('cancel'),
                      type: ButtonType.secondary,
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                  LiveButton(
                      text: localizations.translate('confirm'),
                      type: ButtonType.primary,
                      onTap: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            } else {
              var response = await liveApi.sendCommand(command.id, price);
              if (response.code == 200) {
                showToast();
                Get.find<LiveUserController>().getUserDetail();
                Navigator.of(context).pop();
                arrowSend = true;
              } else {
                throw Exception(response.data["msg"]);
              }
            }
          } catch (e) {
            print(e);
            // show dialog for error
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            arrowSend = true;
          }
        }
      },
      child: Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFFae57ff),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              command.name,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(width: 2),
            Image.asset(
              'packages/live_ui_basic/assets/images/rank_diamond.webp',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 2),
            Text(
              command.price.toString(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
