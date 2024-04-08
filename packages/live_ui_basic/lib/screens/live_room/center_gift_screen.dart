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
  final giftsController = Get.find<GiftsController>();
  final ChatResultController chatResultController =
      Get.find<ChatResultController>();
  String? lottiePath;
  ValueNotifier<int> xCount = ValueNotifier<int>(1);
  ValueNotifier<GiftUserData?> giftUserData =
      ValueNotifier<GiftUserData?>(null);
  int animationLayout = 2;
  int currentRepeatCount = 1;
  int targetRepeatCount = 1;
  AnimationStatusListener? lottielistener;
  StreamSubscription<List<ChatMessage<ChatGiftMessageObjChatData>>>?
      giftCenterMessagesQueueSubscription;

  @override
  void initState() {
    super.initState();
    print('[A] CENTER GIFT SCREEN INIT');
    _lottieController = AnimationController(vsync: this);
    _lottieController.addStatusListener(_animationStatusListener);
    subscribeToGiftMessages();
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

  void subscribeToGiftMessages() {
    giftCenterMessagesQueueSubscription?.cancel();
    giftCenterMessagesQueueSubscription =
        chatResultController.giftCenterMessagesQueue.listen((gifts) {
      if (gifts.isNotEmpty && lottiePath == null) {
        Future.delayed(const Duration(milliseconds: 200), () {
          prepareAndStartAnimation(gifts.first);
        });
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
            lottiePath = gift.animation;
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

  void startAnimationWithGift(
      ChatMessage<ChatGiftMessageObjChatData> giftMessage) {
    var gid = giftMessage.objChat.data.gid;
    var gifts = giftsController.gifts.value;
    if (lottiePath == null) {
      var getGiftsByGid = gifts.where((element) => element.id == gid).toList();
      if (getGiftsByGid.isEmpty) {
        return;
      }
      final gift = getGiftsByGid.first;
      setState(() {
        animationLayout = giftMessage.objChat.data.animationLayout;
        lottiePath = gift.animation;
      });
      _lottieController
        ..reset()
        ..forward();
    } else {
      // 如果没有有效的路径，可能需要处理错误情况
      finishAnimation();
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    giftCenterMessagesQueueSubscription?.cancel();
    giftCenterMessagesQueueSubscription = null;
    super.dispose();
  }

  void finishAnimation() {
    logger.d('[AL] finishAnimation 1');
    if (!mounted) return;
    setState(() {
      lottiePath = null;
      currentRepeatCount = 1;
      targetRepeatCount = 1;
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
