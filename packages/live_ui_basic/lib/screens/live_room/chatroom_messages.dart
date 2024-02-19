import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
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
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();
  LottieData? lottieData;
  bool isLottieDialogOpen = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      var centerGiftAnimationQueue =
          chatResultController.giftCenterMessagesQueue;
      if (centerGiftAnimationQueue.isNotEmpty && !isLottieDialogOpen) {
        var giftMessage = centerGiftAnimationQueue.removeAt(0);
        setLottieAnimation(giftMessage.objChat.data.gid);
      }
    });
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
    timer?.cancel();
    super.dispose();
  }

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
