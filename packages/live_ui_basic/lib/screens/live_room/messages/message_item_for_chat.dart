import 'package:flutter/material.dart';
import 'package:live_core/models/chat_message.dart';

import '../../../localization/live_localization_delegate.dart';

class MessageItemForChat extends StatelessWidget {
  final int pid;
  final ChatMessage<ChatMessageObjChatData> message;

  const MessageItemForChat({Key? key, required this.pid, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    var messageText = "${message.objChat.name} : ${message.objChat.data.src}";

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
