import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/chat_result_controller.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:lottie/lottie.dart';

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

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      var centerGiftAnimationQueue =
          chatResultController.giftCenterMessagesQueue;
      if (centerGiftAnimationQueue.isNotEmpty && !isAnimating) {
        var giftMessage = centerGiftAnimationQueue.removeAt(0);
        setLottieAnimation(giftMessage.objChat.data.gid);
      }
    });

    _lottieController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          isAnimating = false;
          finishAnimation();
        }
      });
  }

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
        child: GestureDetector(
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
      ),
    );
  }
}
