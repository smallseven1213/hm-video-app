import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:live_core/widgets/chatroom_provider.dart';
import 'package:get_storage/get_storage.dart';

import 'chatroom_messages.dart';

class ChatroomLayout extends StatefulWidget {
  final String token;
  const ChatroomLayout({Key? key, required this.token}) : super(key: key);
  @override
  _ChatroomLayoutState createState() => _ChatroomLayoutState();
}

class _ChatroomLayoutState extends State<ChatroomLayout> {
  final TextEditingController _messageController = TextEditingController();
  final LiveSocketIOManager socketManager = LiveSocketIOManager();

  void sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      dynamic jsonData = {
        'msg': message,
        'ntype': 1,
      };

      socketManager.send('chat', jsonData);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatroomProvider(
        chatToken: widget.token,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width - 100,
          child: Column(
            children: [
              const Expanded(child: ChatroomMessages()),
              const SizedBox(height: 25),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '輸入訊息',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: sendMessage,
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ));
  }
}
