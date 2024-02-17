import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();

  @override
  void initState() {
    super.initState();
    // 監聽giftLeftSideMessagesQueue的變化
    chatResultController.giftLeftSideMessagesQueue.listen((_) {
      // 確認隊列中有資料且動畫未在播放時，播放動畫
      if (chatResultController.giftLeftSideMessagesQueue.isNotEmpty &&
          (_lottieController?.isAnimating ?? false) == false) {
        playAnimation();
      }
    });
  }

  void playAnimation() {
    // 取出隊列中的第一筆資料
    var giftData = chatResultController.giftLeftSideMessagesQueue.first;
    // 使用Lottie播放動畫
    _lottieController = AnimationController(vsync: this)
      ..addListener(() {
        if (_lottieController!.isCompleted) {
          // 動畫播放完畢後，移除已播放的動畫資料
          chatResultController.giftLeftSideMessagesQueue.removeAt(0);
          // 更新回chatResultController.giftLeftSideMessagesQueue.value
          chatResultController.giftLeftSideMessagesQueue.refresh();
          _lottieController!.reset();
          // 檢查是否有更多動畫需要播放
          // if (chatResultController.giftLeftSideMessagesQueue.isNotEmpty) {
          //   playAnimation();
          // }
        }
      });
    _lottieController!.forward();
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Obx(() {
        if (chatResultController.giftLeftSideMessagesQueue.isNotEmpty) {
          var giftData = chatResultController.giftLeftSideMessagesQueue.first;
          // 與GiftsController比對出gift data
          var giftInfo = giftsController.gifts.value.firstWhere(
            (element) => element.id == giftData.objChat.data.gid,
          );
          return Row(
            children: [
              Lottie.network(
                height: 80,
                fit: BoxFit.cover,
                giftInfo.animation,
                controller: _lottieController,
                onLoaded: (composition) {
                  // 設置Lottie動畫的總時長，並開始播放
                  _lottieController!
                    ..duration = composition.duration
                    ..forward();
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text('動畫載入失敗');
                },
              )
            ],
          );
        } else {
          // 如果沒有資料，可以顯示一個佔位符或返回Container
          return Container();
        }
      }),
    );
  }
}
