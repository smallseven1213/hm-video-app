import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_core/models/chat_message.dart';

import '../../../libs/format_timestamp.dart';
import '../../../localization/live_localization_delegate.dart';
import 'message_item_for_chat.dart';
import 'message_item_for_command.dart';
import 'message_item_for_gift.dart';

// 多語系mapping，先做假的
// {key: "String"}
const Map<String, String> translations = {
  "userjoin": "已加入",
};

class MessageItem<T> extends StatelessWidget {
  final int pid;
  final ChatMessage<T> message;

  const MessageItem({Key? key, required this.pid, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    var messageText = "";
    if (message.objChat.ntype == MessageType.auction) {
      messageText = "${localizations.translate('bid')} ${message.objChat.data}";
    } else if (message.objChat.ntype == MessageType.system) {
      messageText =
          "${message.objChat.name} ${translations[message.objChat.data] ?? message.objChat.data}";
    } else {
      messageText = "${message.objChat.name} : ${message.objChat.data}";
    }

    if (message.objChat.ntype == MessageType.gift) {
      final messageForGIft = message as ChatMessage<ChatGiftMessageObjChatData>;
      return MessageItemForGift(message: messageForGIft);
    } else if (message.objChat.ntype == MessageType.command) {
      final messageForCommand = message as ChatMessage<String>;
      return MessageItemForCommand(pid: pid, message: messageForCommand);
    } else if (message.objChat.ntype == MessageType.text) {
      final messageForCommand = message as ChatMessage<ChatMessageObjChatData>;
      return MessageItemForChat(pid: pid, message: messageForCommand);
    }
    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // vertical top
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
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
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
