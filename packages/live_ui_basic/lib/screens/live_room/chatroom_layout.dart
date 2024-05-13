import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:live_core/widgets/chatroom_provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../localization/live_localization_delegate.dart';
import 'bottom_sheet_message_input.dart';
import 'chatroom_messages.dart';
import 'left_side_gifts.dart';

class ChatroomLayout extends StatefulWidget {
  final int pid;
  final String token;
  const ChatroomLayout({Key? key, required this.pid, required this.token})
      : super(key: key);
  @override
  ChatroomLayoutState createState() => ChatroomLayoutState();
}

class ChatroomLayoutState extends State<ChatroomLayout> {
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
        // return BottomSheetMessageInput(
        //   textEditingController: _messageController,
        //   onSend: sendMessage,
        // );
        return SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(
                  bottom:
                      kIsWeb ? 0 : MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: 64 + MediaQuery.of(context).padding.bottom,
                child: MessageInputWidget(
                  controller: _messageController,
                  onSend: sendMessage,
                ),
              )),
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
    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible && isBottomSheetDisplayed) {
        Navigator.of(context).pop();
      }
    });
    super.initState();
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
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LeftSideGifts(),
          Expanded(
              child: ChatroomMessages(
            pid: widget.pid,
          )),
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
    );
  }
}
