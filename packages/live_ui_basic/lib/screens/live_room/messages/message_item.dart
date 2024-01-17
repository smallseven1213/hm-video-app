import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/commands_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:live_core/widgets/live_image.dart';

import '../../../libs/format_timestamp.dart';

// 多語系mapping，先做假的
// {key: "String"}
const Map<String, String> translations = {
  "userjoin": "已加入",
};

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
      messageText =
          "${message.objChat.name} ${translations[message.objChat.data] ?? message.objChat.data}";
    } else {
      messageText = "${message.objChat.name} : ${message.objChat.data}";
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // vertical top
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
              child: Container(
                  width: 25.0,
                  height: 25.0,
                  color: Colors.black,
                  child: message.objChat.avatar == ""
                      ? SvgPicture.asset(
                          'packages/live_ui_basic/assets/svgs/default_avatar.svg',
                          fit: BoxFit.cover,
                        )
                      : // message.objChat.avatar use Image remote
                      Image.network(
                          message.objChat.avatar,
                          fit: BoxFit.cover,
                        ))),
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
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: messageText,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 10), // 提供固定的 10 單位空間
                    ),
                    TextSpan(
                      text: formatTimestamp(message.timestamp),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// 截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截截