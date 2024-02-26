import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/x_count.dart';

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
        setLottieAnimation(giftMessage.objChat.data.gid);
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

  void setLottieAnimation(int gid) {
    try {
      isAnimating = true;
      var gift = giftsController.gifts.value
          .firstWhere((element) => element.id == gid);
      if (gift.animation.isNotEmpty) {
        setState(() {
          lottiePath = gift.animation;
        });
      }
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
            ValueListenableBuilder<int>(
              valueListenable: xCount,
              builder: (context, value, child) {
                return XCountWidget(count: value);
              },
            )
          ],
        ),
      ),
    );
  }
}
