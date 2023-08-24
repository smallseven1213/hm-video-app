import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final bool isSelected;
  final String name;
  final VoidCallback? onTap;

  const OptionButton({
    Key? key,
    required this.isSelected,
    required this.name,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: isSelected ? _GradientBorderPainter() : null,
        child: Text(
          name,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey // 使用純色背景
      ..style = PaintingStyle.fill; // 填充而不是描邊

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, 20), const Radius.circular(4)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
