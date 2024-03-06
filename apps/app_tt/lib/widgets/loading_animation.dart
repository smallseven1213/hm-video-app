import 'dart:math' as math show sin, pi;
import 'package:flutter/material.dart';

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

enum LoadingAnimationType { start, end, center }

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    )..repeat();
    _translation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -2.5, end: 6), weight: 15.0),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0.0), weight: 15.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -5), weight: 15.0),
      TweenSequenceItem(tween: Tween(begin: -5, end: -2.5), weight: 15.0),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(_translation.value, 0.0),
              child: Transform.scale(
                // scale: 2 - _scale.value,
                scale: 1,

                child: Ball(
                    color: Color.fromARGB(255, 2, 247, 247).withOpacity(0.8)),
              ),
            ),
            Transform.translate(
              offset: Offset(-_translation.value, 0.0),
              child: Transform.scale(
                // scale: 2 - _scale.value,
                scale: 1,
                child: Ball(color: Color(0xffFF004E).withOpacity(0.8)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Ball extends StatelessWidget {
  final Color color;

  Ball({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
