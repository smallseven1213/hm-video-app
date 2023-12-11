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
  final FocusNode _textFieldFocusNode = FocusNode(); // Persistent FocusNode
  final LiveSocketIOManager socketManager = LiveSocketIOManager();

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, // not true
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_textFieldFocusNode);
        });
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // This adds padding equal to the keyboard height
          ),
          child: Container(
            height: 46.0, // Fixed height for the container
            child: MessageInputWidget(
              controller: _messageController,
              focusNode: _textFieldFocusNode,
              onSend: sendMessage,
            ),
          ),
        );
      },
    ).then((value) {
      // This is to unfocus the text field when the bottom sheet is dismissed
      _textFieldFocusNode.unfocus();
    });
  }

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
  void dispose() {
    // Dispose the controller and focus node when the widget is removed from the widget tree
    _messageController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatroomProvider(
      chatToken: widget.token,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width - 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: ChatroomMessages()),
            const SizedBox(height: 25),
            InkWell(
              onTap: _showBottomSheet,
              child: Image.asset(
                  'packages/live_ui_basic/assets/images/talk_button.webp',
                  width: 33,
                  height: 33),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class MessageInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode; // Add this line
  final VoidCallback onSend;

  const MessageInputWidget({
    Key? key,
    required this.controller,
    required this.focusNode, // Add this line
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        top: 5,
        bottom: 5 + MediaQuery.of(context).padding.bottom,
      ),
      color: const Color(0xFF242a3d),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8), // Adjust the padding as needed
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                borderRadius:
                    BorderRadius.circular(5), // Set the border radius to 5
              ),
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                style: const TextStyle(fontSize: 14, color: Color(0xFF242A3D)),
                decoration: const InputDecoration(
                  hintText: '和主播說些什麼吧///',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7b7b7b)),
                  border: InputBorder.none, // No border
                  contentPadding: EdgeInsets.fromLTRB(
                      10, 10, 10, 10), // Padding inside the TextField
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onSend,
            child: const SizedBox(
              width: 60,
              child: Center(
                child: Text(
                  '送出',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
