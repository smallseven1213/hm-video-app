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

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 120,
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          height: 25,
          // radius 12.5
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            color: const Color(0x65ae57ff),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: message.objChat.data.src,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
