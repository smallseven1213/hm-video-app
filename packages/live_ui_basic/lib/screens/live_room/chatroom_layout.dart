import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:live_core/widgets/chatroom_provider.dart';
import 'package:get_storage/get_storage.dart';

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
      String token = GetStorage().read('live-token');
      String jsonData = jsonEncode({
        'cmd': 'chat',
        'data': {
          'token': token,
          'msg': message,
          'ntype': 1,
        }
      });

      socketManager.send(jsonData);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatroomProvider(
        chatToken: widget.token,
        child: Container(
          height: 300,
          width: 200,
          child: Column(
            children: [
              Expanded(child: Container()),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '輸入訊息',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: sendMessage,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
