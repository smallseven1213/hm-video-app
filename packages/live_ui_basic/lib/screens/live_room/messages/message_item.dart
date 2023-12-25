import 'package:flutter/material.dart';
import 'package:live_core/models/chat_message.dart';

import '../../../libs/format_timestamp.dart';

class MessageItem extends StatelessWidget {
  final ChatMessage message;

  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin top 10
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 25.0,
              height: 25.0,
              // bg red
              color: Colors.red,
              // child: Image.network(
              //   message.objChat.,
              //   fit: BoxFit.cover, // 確保圖片覆蓋整個容器
              // ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Text(message.objChat.name,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                const Text(" : ",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                Text(message.objChat.data,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(width: 5),
                // convert message.timestamp to HH:MM:ss
                Text(formatTimestamp(message.timestamp),
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
