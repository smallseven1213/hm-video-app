import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/commands_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';

import '../../../libs/format_timestamp.dart';

class MessageItem extends StatelessWidget {
  final ChatMessage message;

  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final giftsController = Get.find<GiftsController>();
    final commandsController = Get.find<CommandsController>();
    var messageText = "";
    if (message.objChat.ntype == MessageType.text) {
      messageText = '${message.objChat.name} : ${message.objChat.data}';
    } else if (message.objChat.ntype == MessageType.gift) {
      var giftName = giftsController.gifts.value
          .firstWhere(
              (element) => element.id == int.parse(message.objChat.data))
          .name;
      messageText = "${message.objChat.name} 贈送禮物 $giftName";
    } else if (message.objChat.ntype == MessageType.auction) {
      messageText = "出價 ${message.objChat.data}";
    } else if (message.objChat.ntype == MessageType.command) {
      var commandText = commandsController.commands.value
          .firstWhere(
              (element) => element.id == int.parse(message.objChat.data))
          .name;
      messageText = "${message.objChat.name} 送出指令 $commandText";
    } else if (message.objChat.ntype == MessageType.system) {
      messageText = "${message.objChat.name} ${message.objChat.data}";
    } else {
      messageText = "${message.objChat.name} : ${message.objChat.data}";
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Container(
              width: 25.0,
              height: 25.0,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 120,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x65242a3d),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10, // 水平間距
                runSpacing: 4, // 垂直間距
                children: [
                  Text(
                    messageText,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    formatTimestamp(message.timestamp),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
