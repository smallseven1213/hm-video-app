import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/x_count.dart';

class LeftSideGiftAnimation extends StatefulWidget {
  final int quantity;
  final String jsonPath;
  final VoidCallback? onFinish; // Add onFinish callback

  const LeftSideGiftAnimation(
      {Key? key, required this.quantity, required this.jsonPath, this.onFinish})
      : super(key: key);

  @override
  LeftSideGiftAnimationState createState() => LeftSideGiftAnimationState();
}

class LeftSideGiftAnimationState extends State<LeftSideGiftAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  ValueNotifier<int> currentRepeatCount = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (currentRepeatCount.value < widget.quantity - 1) {
            // 检查是否达到重复次数
            // 未达到，重置并重新启动动画
            currentRepeatCount.value++;
            _lottieController
              ..reset()
              ..forward();
          } else {
            // 达到重复次数，调用完成回调
            widget.onFinish?.call();
          }
        }
      });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Lottie.network(
          widget.jsonPath,
          controller: _lottieController,
          onLoaded: (composition) {
            var duration = composition.duration;
            // if (duration < const Duration(milliseconds: 1000)) {
            //   duration = const Duration(milliseconds: 1000);
            // }
            // duration = duration * widget.quantity;
            print("duration $duration");
            _lottieController
              ..duration = duration
              ..forward();
          },
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Lottie.asset(
              'packages/live_ui_basic/assets/lotties/present.json',
              controller: _lottieController,
              onLoaded: (composition) {
                var duration = composition.duration;
                // if (duration < const Duration(milliseconds: 1000)) {
                //   duration = const Duration(milliseconds: 1000);
                // }
                // duration = duration * widget.quantity;
                _lottieController
                  ..duration = duration
                  // ..repeat(
                  //   max: widget.quantity.toDouble(),
                  // )
                  ..forward();
              },
            );
          },
        ),
        ValueListenableBuilder<int>(
          valueListenable: currentRepeatCount,
          builder: (context, value, child) {
            return XCountWidget(count: value);
          },
        )
      ],
    );
  }
}
