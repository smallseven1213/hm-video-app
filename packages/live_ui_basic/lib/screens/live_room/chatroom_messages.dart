import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';

import 'messages/message_item.dart';

class ChatroomMessages extends StatefulWidget {
  const ChatroomMessages({Key? key}) : super(key: key);
  @override
  _ChatroomMessagesState createState() => _ChatroomMessagesState();
}

class _ChatroomMessagesState extends State<ChatroomMessages>
    with SingleTickerProviderStateMixin {
  final GiftsController giftsController = Get.find<GiftsController>();
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() => ListView.builder(
                reverse: true,
                // padding 0
                padding: EdgeInsets.zero,
                itemCount: chatResultController.commonMessages.length,
                itemBuilder: (context, index) {
                  int reversedIndex =
                      chatResultController.commonMessages.length - 1 - index;
                  return MessageItem(
                      message: chatResultController
                          .commonMessages.value[reversedIndex]);
                },
              )),
        ),
      ],
    );
  }
}
