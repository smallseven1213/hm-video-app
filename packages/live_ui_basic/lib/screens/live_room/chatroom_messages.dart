import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';

import 'messages/message_item.dart';

class ChatroomMessages extends StatefulWidget {
  const ChatroomMessages({Key? key}) : super(key: key);
  @override
  _ChatroomMessagesState createState() => _ChatroomMessagesState();
}

class _ChatroomMessagesState extends State<ChatroomMessages> {
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  List<ChatMessage> messages = []; // 用於存儲聊天訊息的狀態變量

  @override
  void initState() {
    super.initState();
    socketManager.socket!.on('chatresult', (data) {
      var decodedData = jsonDecode(data);
      List<ChatMessage> newMessages = (decodedData as List)
          .map((item) => ChatMessage.fromJson(item))
          .toList();
      setState(() {
        messages.addAll(newMessages);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true, // 最新訊息顯示在底部
            itemCount: messages.length,
            itemBuilder: (context, index) {
              // 為了正確顯示，需要反轉 index
              int reversedIndex = messages.length - 1 - index;
              return MessageItem(message: messages[reversedIndex]);
            },
          ),
        ),
      ],
    );
  }
}
