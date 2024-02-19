import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/models/gift.dart';
import 'package:lottie/lottie.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';

class GiftAnimationData {
  int quantity;
  String userName;
  String userAvatar;
  String giftName;
  String giftLottiePath;

  GiftAnimationData({
    required this.quantity,
    required this.userName,
    required this.userAvatar,
    required this.giftName,
    required this.giftLottiePath,
  });
}

class LeftSideGifts extends StatefulWidget {
  const LeftSideGifts({Key? key}) : super(key: key);

  @override
  _LeftSideGiftsState createState() => _LeftSideGiftsState();
}

class _LeftSideGiftsState extends State<LeftSideGifts>
    with SingleTickerProviderStateMixin {
  AnimationController? _lottieController;
  final GiftsController giftsController = Get.find<GiftsController>();
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();
  GiftAnimationData? giftAnimationData;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    chatResultController.giftLeftSideMessagesQueue
        .listen((_) => playAnimation());
  }

  void playAnimation() {
    if (chatResultController.giftLeftSideMessagesQueue.isEmpty ||
        _lottieController!.isAnimating) return;

    var giftData = chatResultController.giftLeftSideMessagesQueue.first;
    Gift giftInfo = giftsController.gifts.value
        .firstWhere((element) => element.id == giftData.objChat.data.gid);

    setState(() {
      giftAnimationData = GiftAnimationData(
        quantity: giftData.objChat.data.quantity,
        userName: giftData.objChat.name,
        userAvatar: giftData.objChat.avatar,
        giftName: giftInfo.name,
        giftLottiePath: giftInfo.animation,
      );
    });

    _lottieController!
      ..reset()
      ..addListener(() {
        if (_lottieController!.isCompleted) {
          chatResultController.giftLeftSideMessagesQueue.removeAt(0);
          // 检查队列是否为空，如果为空，则将 giftAnimationData 设置为 null
          if (chatResultController.giftLeftSideMessagesQueue.isEmpty) {
            setState(() {
              giftAnimationData = null;
            });
          } else {
            // 如果队列不为空，尝试播放下一个动画
            playAnimation();
          }
          _lottieController!.reset();
        }
      })
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80,
      child: giftAnimationData == null
          ? Container()
          : Lottie.network(
              giftAnimationData!.giftLottiePath,
              controller: _lottieController,
              onLoaded: (composition) {
                _lottieController!.duration = composition.duration;
              },
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Text('動畫載入失敗'),
            ),
    );
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    super.dispose();
  }
}
