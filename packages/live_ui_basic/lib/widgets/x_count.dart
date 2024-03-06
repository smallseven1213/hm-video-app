import 'package:flutter/material.dart';

class XCountWidget extends StatefulWidget {
  final int count;

  const XCountWidget({Key? key, required this.count}) : super(key: key);

  @override
  XCountWidgetState createState() => XCountWidgetState();
}

class XCountWidgetState extends State<XCountWidget>
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
  void didUpdateWidget(XCountWidget oldWidget) {
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
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'x${widget.count}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: widget.count > 5
                  ? widget.count > 10
                      ? 22
                      : 20
                  : 18,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 2,
                ),
              ],
            ),
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
