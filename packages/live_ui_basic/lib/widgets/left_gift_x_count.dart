import 'package:flutter/material.dart';

class LeftGiftXCountWidget extends StatefulWidget {
  final int count;

  const LeftGiftXCountWidget({Key? key, required this.count}) : super(key: key);

  @override
  LeftGiftXCountWidgetState createState() => LeftGiftXCountWidgetState();
}

class LeftGiftXCountWidgetState extends State<LeftGiftXCountWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // 示例动画持续时间
    );
    _scaleAnimation = Tween<double>(begin: 1.5, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward(); // 启动动画
  }

  @override
  void didUpdateWidget(LeftGiftXCountWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _controller
        ..reset()
        ..forward(); // 当 count 更新时重置并重新启动动画
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'x${widget.count}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            // color: const Color(0xFFcf5fb0),
            fontWeight: FontWeight.w600,
            fontSize: widget.count > 5
                ? widget.count > 10
                    ? 28
                    : 27
                : 26,
            shadows: const [
              Shadow(
                color: Colors.black,
                blurRadius: 2,
              ),
            ],
            // shadows: const [
            //   Shadow(
            //     // Bottom Left
            //     offset: Offset(-2, -2),
            //     color: Colors.white,
            //   ),
            //   Shadow(
            //     // Bottom Right
            //     offset: Offset(2, -2),
            //     color: Colors.white,
            //   ),
            //   Shadow(
            //     // Top Right
            //     offset: Offset(2, 2),
            //     color: Colors.white,
            //   ),
            //   Shadow(
            //     // Top Left
            //     offset: Offset(-2, 2),
            //     color: Colors.white,
            //   ),
            //   Shadow(
            //     color: Colors.black,
            //     blurRadius: 2,
            //   ),
            // ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
