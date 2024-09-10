import 'package:flutter/material.dart';

class DotLineAnimation extends StatefulWidget {
  const DotLineAnimation({super.key});

  @override
  DotLineAnimationState createState() => DotLineAnimationState();
}

class DotLineAnimationState extends State<DotLineAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDot(_animation.value),
        const SizedBox(width: 8),
        buildLine(_animation.value),
        const SizedBox(width: 8),
        buildDot(1 - _animation.value),
      ],
    );
  }

  Widget buildDot(double scale) {
    return Container(
        width: 5 * scale,
        height: 5 * scale,
        decoration: BoxDecoration(
            color: const Color(0xffF4D743),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xffF4D743).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ]));
  }

  Widget buildLine(double scale) {
    return Container(
      width: 15 * scale + 5,
      height: 5,
      decoration: BoxDecoration(
          color: const Color(0xffF4D743),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffF4D743).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ]),
    );
  }
}
