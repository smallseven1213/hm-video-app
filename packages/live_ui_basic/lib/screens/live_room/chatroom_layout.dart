import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:live_core/widgets/chatroom_provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
  late StreamSubscription<bool> keyboardSubscription;

  bool isBottomSheetDisplayed = false;

  void _showBottomSheet() {
    isBottomSheetDisplayed = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: 64 + MediaQuery.of(context).padding.bottom,
              child: MessageInputWidget(
                controller: _messageController,
                onSend: sendMessage,
              ),
            )
            // child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            // MessageInputWidget(
            //   controller: _messageController,
            //   onSend: sendMessage,
            // )
            //   ],
            // ),
            );
      },
    ).whenComplete(() {
      isBottomSheetDisplayed = false;
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
      Navigator.of(context)
          .pop(); // Dismiss the bottom sheet after sending the message
    }
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible && isBottomSheetDisplayed) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    // Dispose the controller and focus node when the widget is removed from the widget tree
    _messageController.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatroomProvider(
      chatToken: widget.token,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
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

class MessageInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputWidget({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  _MessageInputWidgetState createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                autofocus: true,
                controller: widget.controller,
                style: const TextStyle(fontSize: 14, color: Color(0xFF242A3D)),
                decoration: const InputDecoration(
                  hintText: '和主播說些什麼吧...',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7b7b7b)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.onSend();
            },
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
