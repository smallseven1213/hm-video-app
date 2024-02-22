import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LeftSideGiftAnimation extends StatefulWidget {
  final int quantity;
  final String jsonPath;
  final VoidCallback? onFinish; // Add onFinish callback

  const LeftSideGiftAnimation(
      {Key? key, required this.quantity, required this.jsonPath, this.onFinish})
      : super(key: key);

  @override
  _LeftSideGiftAnimationState createState() => _LeftSideGiftAnimationState();
}

class _LeftSideGiftAnimationState extends State<LeftSideGiftAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  int _currentRepeatCount = 0;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_currentRepeatCount < widget.quantity - 1) {
            // 检查是否达到重复次数
            // 未达到，重置并重新启动动画
            _currentRepeatCount++;
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
    return Lottie.network(
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
    );
  }
}
