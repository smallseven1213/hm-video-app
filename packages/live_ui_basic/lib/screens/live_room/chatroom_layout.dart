import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:live_core/widgets/chatroom_provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../localization/live_localization_delegate.dart';
import 'message_input.dart';
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
  // late StreamSubscription<bool> keyboardSubscription;

  bool isBottomSheetDisplayed = false;

  @override
  void initState() {
    // var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    // keyboardSubscription =
    //     keyboardVisibilityController.onChange.listen((bool visible) {
    //   if (!visible && isBottomSheetDisplayed) {
    //     Navigator.of(context).pop();
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final liveRoomController =
        Get.find<LiveRoomController>(tag: widget.pid.toString());
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
            onTap: liveRoomController.toggleDisplayChatInput,
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
