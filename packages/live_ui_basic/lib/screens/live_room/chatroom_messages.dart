import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';

import 'lottie_dialog.dart';
import 'messages/message_item.dart';

class LottieData {
  final LottieDataProvider provider;
  final String path;
  LottieData({required this.provider, required this.path});
}

class ChatroomMessages extends StatefulWidget {
  const ChatroomMessages({Key? key}) : super(key: key);
  @override
  _ChatroomMessagesState createState() => _ChatroomMessagesState();
}

class _ChatroomMessagesState extends State<ChatroomMessages>
    with SingleTickerProviderStateMixin {
  final GiftsController giftsController = Get.find<GiftsController>();
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  List<ChatMessage> messages = [];
  LottieData? lottieData;
  bool isLottieDialogOpen = false;

  @override
  void initState() {
    super.initState();

    socketManager.socket!.on('chatresult', (data) => handleChatResult(data));
  }

  void handleChatResult(dynamic data) {
    var decodedData = jsonDecode(data);
    List<ChatMessage> newMessages = (decodedData as List)
        .map((item) => ChatMessage.fromJson(item))
        .toList();

    try {
      var latestGiftMessage = newMessages
          .lastWhere((element) => element.objChat.ntype == MessageType.gift);
      setLottieAnimation(latestGiftMessage.objChat.data);
    } catch (e) {}

    setState(() {
      messages.addAll(newMessages);
    });
  }

  void setLottieAnimation(String data) {
    try {
      var giftId = int.parse(data);
      var gift = giftsController.gifts.value
          .firstWhere((element) => element.id == giftId);
      if (gift.animation.isNotEmpty) {
        showLottieDialog(LottieDataProvider.network, gift.animation);
      }
    } catch (e) {
      showLottieDialog(LottieDataProvider.asset, 'assets/lotties/present.json');
    }
  }

  void showLottieDialog(LottieDataProvider provider, String path) {
    if (isLottieDialogOpen) return;

    isLottieDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent, // Transparent background
      builder: (BuildContext context) {
        return LottieDialog(
          path: path,
          provider: provider,
        );
      },
    ).then((_) {
      setState(() {
        isLottieDialogOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              int reversedIndex = messages.length - 1 - index;
              return MessageItem(message: messages[reversedIndex]);
            },
          ),
        ),
      ],
    );
  }
}
