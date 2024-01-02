import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/commands_controller.dart';
import 'package:live_core/controllers/live_user_controller.dart';
import 'package:live_core/models/command.dart';

import '../../libs/showLiveDialog.dart';
import '../../widgets/live_button.dart';
import 'right_corner_controllers/user_diamonds.dart';

final liveApi = LiveApi();

class CommandController extends StatelessWidget {
  const CommandController({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Commands();
          },
        );
      },
      child: Image.asset('packages/live_ui_basic/assets/images/ic_list_c.webp',
          width: 33, height: 33),
    );
  }
}

class Commands extends StatelessWidget {
  const Commands({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final commandsController = Get.find<CommandsController>();
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
                '指令清單',
                style: TextStyle(
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
          UserDiamonds(),
          const SizedBox(height: 15),
          Expanded(
              child: Obx(
            () => ListView.builder(
              itemCount: commandsController.commands.value.length ~/ 2,
              itemBuilder: (context, index) {
                var startIndex = index * 2;
                var endIndex = startIndex + 1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CommandItem(
                          command:
                              commandsController.commands.value[startIndex],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CommandItem(
                          command: commandsController.commands.value[endIndex],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ))
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
        child: const Center(
          child: Text(
            "發送成功",
            style: TextStyle(color: Colors.white, fontSize: 12.7),
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
                title: '鑽石不足',
                content: Center(
                  child: Text('鑽石不足，請前往充值',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
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
