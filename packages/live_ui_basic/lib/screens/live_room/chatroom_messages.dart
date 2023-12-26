import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:lottie/lottie.dart';

import 'messages/message_item.dart';

enum LottieDataProvider { network, asset }

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

  AnimationController? lottieController;

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(vsync: this);
    socketManager.socket!.on('chatresult', (data) => handleChatResult(data));
  }

  @override
  void dispose() {
    lottieController?.dispose();
    super.dispose();
  }

  void handleChatResult(dynamic data) {
    var decodedData = jsonDecode(data);
    List<ChatMessage> newMessages = (decodedData as List)
        .map((item) => ChatMessage.fromJson(item))
        .toList();

    // for (var element in newMessages) {
    //   if (element.objChat.ntype == MessageType.gift) {
    //     setLottieAnimation(element.objChat.data);
    //   }
    // }
    // refactor top-up code, get latest record and setAnimation
    try {
      var latestGiftMessage = newMessages
          .lastWhere((element) => element.objChat.ntype == MessageType.gift);
      setLottieAnimation(latestGiftMessage.objChat.data);
    } catch (e) {}

    // ForTest
    // showLottieDialog(LottieDataProvider.network,
    //     'https://cdn.hubeibk.com/live/webp/app_gifts/018c5766-ab64-7360-a2ce-195b0455ebb1.json');
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
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent, // Transparent background
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent Dialog
          child: provider == LottieDataProvider.network
              ? Lottie.network(
                  path,
                  controller: lottieController,
                  onLoaded: (composition) {
                    // Set the duration and start the animation
                    lottieController!
                      ..duration = composition.duration
                      ..forward();
                  },
                )
              : Lottie.asset(
                  path,
                  controller: lottieController,
                ),
        );
      },
    ).then((_) {
      // When dialog is dismissed
      if (lottieController != null) {
        lottieController!.dispose();
        lottieController = null;
      }
    });

    lottieController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop(); // Close the dialog
      }
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
