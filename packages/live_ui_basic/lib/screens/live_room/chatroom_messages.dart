import 'dart:async';
import 'dart:collection';
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
  Timer? timer;

  // 用於type2與3的queue
  Queue<ChatMessage<ChatGiftMessageObjChatData>> centerGiftAnimationQueue =
      Queue<ChatMessage<ChatGiftMessageObjChatData>>();

  @override
  void initState() {
    super.initState();
    socketManager.socket!.on('chatresult', (data) => handleChatResult(data));

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (centerGiftAnimationQueue.isNotEmpty && !isLottieDialogOpen) {
        var giftMessage = centerGiftAnimationQueue.removeFirst();
        setLottieAnimation(giftMessage.objChat.data.gid);
      }
    });
  }

  void handleChatResult(dynamic data) {
    var decodedData = jsonDecode(data);
    List<ChatMessage> newMessages = (decodedData as List).map((item) {
      if (item['objChat']['ntype'] == 3) {
        return ChatMessage<ChatGiftMessageObjChatData>.fromJson(item);
      } else {
        return ChatMessage<String>.fromJson(item);
      }
    }).toList();

    setState(() {
      messages.addAll(newMessages);
    });

    for (var message in newMessages) {
      if (message.objChat.ntype == MessageType.gift) {
        var giftMesssage = message as ChatMessage<ChatGiftMessageObjChatData>;
        if (giftMesssage.objChat.data.animationLayout == 2 ||
            giftMesssage.objChat.data.animationLayout == 3) {
          updateCenterGiftQueue(
              giftMesssage, giftMesssage.objChat.data.animationLayout);
        }
      }
    }
  }

  // 大圖用
  void updateCenterGiftQueue(
      ChatMessage<ChatGiftMessageObjChatData> message, int animationLayout) {
    for (var i = 0; i < message.objChat.data.quantity; i++) {
      centerGiftAnimationQueue.add(message);
    }
  }

  void setLottieAnimation(int gid) {
    try {
      var gift = giftsController.gifts.value
          .firstWhere((element) => element.id == gid);
      if (gift.animation.isNotEmpty) {
        showLottieDialog(
          LottieDataProvider.network,
          gift.animation,
          onFinish: () => isLottieDialogOpen = false,
        );
      }
    } catch (e) {
      showLottieDialog(
        LottieDataProvider.asset,
        'packages/live_ui_basic/assets/lotties/present.json',
        onFinish: () => isLottieDialogOpen = false,
      );
    }
  }

  void showLottieDialog(LottieDataProvider provider, String path,
      {VoidCallback? onFinish}) {
    isLottieDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return LottieDialog(
          path: path,
          provider: provider,
          onFinish: onFinish ?? () {},
        );
      },
    ).then((_) {
      isLottieDialogOpen = false;
    });
  }

  // dispose
  @override
  void dispose() {
    socketManager.socket!.off('chatresult');
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            // padding 0
            padding: EdgeInsets.zero,
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
