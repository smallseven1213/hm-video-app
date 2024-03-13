import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:lottie/lottie.dart';

import '../../localization/live_localization_delegate.dart';
import '../../widgets/left_gift_x_count.dart';

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
  LeftSideGiftsState createState() => LeftSideGiftsState();
}

class LeftSideGiftsState extends State<LeftSideGifts>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  int currentRepeatCount = 1;
  int targetRepeatCount = 1;
  GiftAnimationData? giftAnimationData;
  ValueNotifier<int> xCount = ValueNotifier<int>(1);
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();
  final giftsController = Get.find<GiftsController>();
  StreamSubscription<List<ChatMessage<ChatGiftMessageObjChatData>>>?
      giftMessagesQueueSubscription;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _lottieController.addStatusListener(_animationStatusListener);
    subscribeToGiftMessages();
  }

  void subscribeToGiftMessages() {
    giftMessagesQueueSubscription?.cancel();
    giftMessagesQueueSubscription =
        chatResultController.giftLeftSideMessagesQueue.listen((gifts) {
      if (gifts.isNotEmpty && giftAnimationData == null) {
        prepareAndStartAnimation(gifts.first);
      }
    });
  }

  void prepareAndStartAnimation(
      ChatMessage<ChatGiftMessageObjChatData> giftMessage) {
    try {
      var getGiftById = giftsController.gifts.value
          .where((element) => element.id == giftMessage.objChat.data.gid);
      if (getGiftById.isEmpty) {
        return;
      }
      var gift = getGiftById.first;
      if (gift.animation.isNotEmpty) {
        if (mounted) {
          print('[AL] prepareAndStartAnimation 1');
          setState(() {
            giftAnimationData = GiftAnimationData(
              quantity: giftMessage.objChat.data.quantity,
              userName: giftMessage.objChat.name,
              userAvatar: giftMessage.objChat.avatar,
              giftName: gift.name,
              giftLottiePath: gift.animation,
            );
            targetRepeatCount = giftMessage.objChat.data.quantity;
            currentRepeatCount = 1;
          });
          // _lottieController
          //   ..reset()
          //   ..forward();
        }
      }
    } catch (e) {
      print('[AL] error: $e');
      finishAnimation();
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    print('[AL] listener status: $status');
    if (status == AnimationStatus.completed) {
      print('[AL] completed');
      if (currentRepeatCount < targetRepeatCount) {
        print('[AL] completed A1');
        _lottieController.forward(from: 0.0);
        currentRepeatCount++;
        xCount.value = currentRepeatCount;
      } else {
        print('[AL] completed A2');
        finishAnimation();
        chatResultController.removeGiftLeftSideMessagesQueueByIndex(0);
      }
    }
  }

  void finishAnimation() {
    print('[AL] finishAnimation 1');
    if (!mounted) return;
    print('[AL] finishAnimation 2');
    setState(() {
      currentRepeatCount = 1;
      targetRepeatCount = 1;
      giftAnimationData = null;
      xCount.value = 1;
    });
    print('[AL] finishAnimation 3');
    // _lottieController.reset();
    print('[AL] finishAnimation 5');
  }

  @override
  void dispose() {
    _lottieController.dispose();
    giftMessagesQueueSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    print('[AL] build LeftSideGifts giftAnimationData: $giftAnimationData');
    return giftAnimationData == null
        ? Container()
        : Stack(
            children: [
              IntrinsicWidth(
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0x65ae57ff),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                              child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  color: Colors.black,
                                  child:
                                      giftAnimationData?.userAvatar.isEmpty ==
                                              true
                                          ? SvgPicture.asset(
                                              'packages/live_ui_basic/assets/svgs/default_avatar.svg',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              giftAnimationData!.userAvatar,
                                              fit: BoxFit.cover,
                                            ))),
                          const SizedBox(width: 6.7),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                giftAnimationData?.userName ??
                                    localizations.translate('a_certain_user'),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                '${localizations.translate('send_gift')} ${giftAnimationData?.giftName}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 40,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              // Positioned(
              //   right: 10,
              //   bottom: 0,
              //   child: Container(
              //     color: Colors.red,
              //     width: 40,
              //     height: 40,
              //   ),
              // ),
              // 在此stack的左邊加入禮物動畫
              Positioned(
                right: 10,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.network(
                      giftAnimationData!.giftLottiePath,
                      controller: _lottieController,
                      onLoaded: (composition) {
                        print(
                            '[AL] composition.duration: ${composition.duration}');
                        var duration = composition.duration;
                        _lottieController
                          ..duration = duration
                          ..reset()
                          ..forward();
                      },
                      width: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Lottie.asset(
                          'packages/live_ui_basic/assets/lotties/present.json',
                          controller: _lottieController,
                          onLoaded: (composition) {
                            var duration = composition.duration;
                            _lottieController
                              ..duration = duration
                              ..forward();
                          },
                        );
                      },
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: xCount,
                      builder: (context, value, child) {
                        return LeftGiftXCountWidget(count: value);
                      },
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
