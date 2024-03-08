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
    chatResultController.giftCenterMessagesQueue.listen((gifts) {
      if (gifts.isNotEmpty && !isAnimating) {
        var getGift = gifts.first;
        setLottieAnimation(getGift);
        // 開始播放動畫，但過了2000 * quantity毫秒後，要移除目前的gift from queue，並將isAnimating設為false
        timer = Timer(
            Duration(milliseconds: 2000 * getGift.objChat.data.quantity), () {
          finishAnimation();
          isAnimating = false;
          chatResultController.giftCenterMessagesQueue.remove(getGift);
        });

        // 如果quantity > 1，則要重複播放動畫
        if (getGift.objChat.data.quantity > 1) {
          currentRepeatCount = 0;
          targetRepeatCount = getGift.objChat.data.quantity;
          _lottieController.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              currentRepeatCount++;
              if (currentRepeatCount < targetRepeatCount) {
                _lottieController.reset();
                _lottieController.forward();
              }
            }
          });
        }
      }
    });
  }

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
