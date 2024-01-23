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

  // Using ValueNotifier for the gift message queue
  ValueNotifier<Queue<ChatMessage>> giftMessageQueue =
      ValueNotifier(Queue<ChatMessage>());

  @override
  void initState() {
    super.initState();
    socketManager.socket!.on('chatresult', (data) => handleChatResult(data));

    // Adding listener to the giftMessageQueue
    giftMessageQueue.addListener(() {
      if (giftMessageQueue.value.isNotEmpty && !isLottieDialogOpen) {
        processGiftQueue();
      }
    });
  }

  void handleChatResult(dynamic data) {
    var decodedData = jsonDecode(data);
    List<ChatMessage> newMessages = (decodedData as List)
        .map((item) => ChatMessage.fromJson(item))
        .toList();

    setState(() {
      messages.addAll(newMessages);
    });

    for (var message in newMessages) {
      if (message.objChat.ntype == MessageType.gift) {
        updateGiftQueue(message);
      }
    }
  }

  void updateGiftQueue(ChatMessage message) {
    // Create a new instance of Queue with the current items and the new message
    var updatedQueue = Queue<ChatMessage>.from(giftMessageQueue.value)
      ..add(message);

    // Update the ValueNotifier with the new queue instance
    giftMessageQueue.value = updatedQueue;
  }

  void processGiftQueue() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (giftMessageQueue.value.isNotEmpty && !isLottieDialogOpen) {
        var giftMessage = giftMessageQueue.value.removeFirst();
        // showLottieDialog(
        //   LottieDataProvider.network,
        //   giftMessage.objChat.data,
        //   onFinish: () => isLottieDialogOpen = false,
        // );
        setLottieAnimation(giftMessage.objChat.data);
      } else {
        timer.cancel();
      }
    });
  }

  void setLottieAnimation(String data) {
    try {
      var giftId = int.parse(data);
      var gift = giftsController.gifts.value
          .firstWhere((element) => element.id == giftId);
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
        'assets/lotties/present.json',
        onFinish: () => isLottieDialogOpen = false,
      );
    }
  }

  void showLottieDialog(LottieDataProvider provider, String path,
      {VoidCallback? onFinish}) {
    if (isLottieDialogOpen) return;

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
      if (mounted) {
        setState(() {
          isLottieDialogOpen = false;
        });
      }
    });
  }

  // dispose
  @override
  void dispose() {
    socketManager.socket!.off('chatresult');
    giftMessageQueue.dispose();
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
