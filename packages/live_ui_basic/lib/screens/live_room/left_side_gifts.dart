import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:live_core/models/gift.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'left_side_gift_animation.dart';

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
  late AnimationController _lottieController;
  final GiftsController giftsController = Get.find<GiftsController>();
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();
  GiftAnimationData? giftAnimationData;
  bool isAnimating = false;
  late Timer timer;

  @override
  void initState() {
    _lottieController = AnimationController(vsync: this);
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (isAnimating == true) return;
      var giftLeftSideMessagesQueue =
          chatResultController.giftLeftSideMessagesQueue;
      if (giftLeftSideMessagesQueue.isNotEmpty && !isAnimating) {
        var giftMessage =
            chatResultController.removeGiftLeftSideMessagesQueueByIndex(0);
        if (giftMessage != null) {
          playAnimation(giftMessage);
        }
      } else if (giftLeftSideMessagesQueue.isEmpty) {
        setState(() {
          isAnimating = false;
          giftAnimationData = null;
        });
      }
    });
    super.initState();
  }

  void playAnimation(ChatMessage<ChatGiftMessageObjChatData> giftMessage) {
    print("playAnimation");
    isAnimating = true;
    Gift giftInfo = giftsController.gifts.value
        .firstWhere((element) => element.id == giftMessage.objChat.data.gid);

    setState(() {
      giftAnimationData = GiftAnimationData(
        quantity: giftMessage.objChat.data.quantity,
        userName: giftMessage.objChat.name,
        userAvatar: giftMessage.objChat.avatar,
        giftName: giftInfo.name,
        giftLottiePath: giftInfo.animation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: giftAnimationData == null
          ? Container()
          : Row(
              children: [
                ClipOval(
                    child: Container(
                        width: 25.0,
                        height: 25.0,
                        color: Colors.black,
                        child: giftAnimationData?.userAvatar.isEmpty == true
                            ? SvgPicture.asset(
                                'packages/live_ui_basic/assets/svgs/default_avatar.svg',
                                fit: BoxFit.cover,
                              )
                            : // message.objChat.avatar use Image remote
                            Image.network(
                                giftAnimationData!.userAvatar,
                                fit: BoxFit.cover,
                              ))),
                const SizedBox(width: 6),
                Column(
                  children: [
                    Text(
                      giftAnimationData?.userName ?? "某位使用者",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '贈送禮物 ${giftAnimationData?.giftName}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                LeftSideGiftAnimation(
                  key: UniqueKey(),
                  quantity: giftAnimationData?.quantity ?? 1,
                  jsonPath: giftAnimationData?.giftLottiePath ?? "",
                  onFinish: () {
                    print("playAnimation end");
                    isAnimating = false;
                  },
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    timer.cancel();
    super.dispose();
  }
}
