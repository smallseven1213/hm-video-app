import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:lottie/lottie.dart';

import '../../localization/live_localization_delegate.dart';

class GiftUserData {
  String userName;
  String userAvatar;
  String giftName;

  GiftUserData({
    required this.userName,
    required this.userAvatar,
    required this.giftName,
  });
}

class CenterGiftScreen extends StatefulWidget {
  const CenterGiftScreen({
    Key? key,
  }) : super(key: key);

  @override
  CenterGiftScreenState createState() => CenterGiftScreenState();
}

class CenterGiftScreenState extends State<CenterGiftScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  var isAnimating = false;
  final giftsController = Get.find<GiftsController>();
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();
  String? lottiePath;
  Timer? timer;
  ValueNotifier<int> xCount = ValueNotifier<int>(1);
  ValueNotifier<GiftUserData?> giftUserData =
      ValueNotifier<GiftUserData?>(null);
  int animationLayout = 2;
  int currentRepeatCount = 0;
  int targetRepeatCount = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      var centerGiftAnimationQueue =
          chatResultController.giftCenterMessagesQueue;
      if (centerGiftAnimationQueue.isNotEmpty && !isAnimating) {
        var giftMessage = centerGiftAnimationQueue.removeAt(0);
        targetRepeatCount = giftMessage.objChat.data.quantity; // 设置目标重复次数
        currentRepeatCount = 0; // 重置当前重复次数
        xCount.value = 1; // 重置xCount
        setLottieAnimation(giftMessage);
      }
    });

    _lottieController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          if (currentRepeatCount < targetRepeatCount - 1) {
            currentRepeatCount++;
            xCount.value = currentRepeatCount + 1;
            _lottieController.forward(from: 0.0); // 从头开始动画
          } else {
            isAnimating = false;
            finishAnimation();
          }
        }
      });
  }

  // 其他方法保持不变

  @override
  void dispose() {
    timer?.cancel();
    _lottieController.dispose();
    super.dispose();
  }

  void setLottieAnimation(ChatMessage<ChatGiftMessageObjChatData> giftMessage) {
    try {
      isAnimating = true;
      var gid = giftMessage.objChat.data.gid;
      var gift = giftsController.gifts.value
          .firstWhere((element) => element.id == gid);
      if (gift.animation.isNotEmpty) {
        setState(() {
          animationLayout = giftMessage.objChat.data.animationLayout;
          lottiePath = gift.animation;
        });
      }
      giftUserData.value = GiftUserData(
        userName: giftMessage.objChat.name,
        userAvatar: giftMessage.objChat.avatar,
        giftName: gift.name,
      );
    } catch (e) {
      isAnimating = false;
      setState(() {
        lottiePath = null;
      });
    }
  }

  void finishAnimation() {
    _lottieController.reset();
    setState(() {
      lottiePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    if (lottiePath == null) {
      return const SizedBox();
    }
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          // horizaontal center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              // onTap: finishAnimation,
              onTap: () {},
              child: Center(
                  child: Lottie.network(
                height: animationLayout == 2 ? 250 : null,
                width: animationLayout == 3 ? double.infinity : null,
                lottiePath ?? "",
                controller: _lottieController,
                onLoaded: (composition) {
                  var duration = composition.duration;
                  _lottieController
                    ..duration = duration
                    ..forward();
                },
                errorBuilder: (context, error, stackTrace) {
                  return Lottie.asset(
                    'packages/live_ui_basic/assets/lotties/present.json',
                    height: animationLayout == 2 ? 250 : null,
                    width: animationLayout == 3 ? double.infinity : null,
                    controller: _lottieController,
                    onLoaded: (composition) {
                      var duration = composition.duration;
                      _lottieController
                        ..duration = duration
                        ..forward();
                    },
                  );
                },
              )),
            ),
            animationLayout == 2
                ? SizedBox(
                    height: 25,
                    child: ValueListenableBuilder<GiftUserData?>(
                      valueListenable: giftUserData,
                      builder: (context, value, child) {
                        if (value == null) {
                          return const SizedBox();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 25,
                              decoration: BoxDecoration(
                                color: const Color(0xffae57ff),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  ClipOval(
                                      child: Container(
                                          width: 25.0,
                                          height: 25.0,
                                          color: Colors.black,
                                          child: giftUserData.value?.userAvatar
                                                      .isEmpty ==
                                                  true
                                              ? SvgPicture.asset(
                                                  'packages/live_ui_basic/assets/svgs/default_avatar.svg',
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  giftUserData
                                                      .value!.userAvatar,
                                                  fit: BoxFit.cover,
                                                ))),
                                  const SizedBox(width: 6.7),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          giftUserData.value?.userName ??
                                              localizations
                                                  .translate('a_certain_user'),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          '${localizations.translate('send_gift')} ${giftUserData.value?.giftName}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6.7),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : const SizedBox(),
            // ValueListenableBuilder<int>(
            //   valueListenable: xCount,
            //   builder: (context, value, child) {
            //     return XCountWidget(count: value);
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
