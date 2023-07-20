import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

class OptionButton extends StatelessWidget {
  final bool isSelected;
  final String name;
  final VoidCallback? onTap;
  final FilterScreenController controller = Get.find();

  OptionButton({
    Key? key,
    required this.isSelected,
    required this.name,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 20, // 修改高度
        child: CustomPaint(
          painter: isSelected ? _GradientBorderPainter() : null,
          child: Padding(
            // 添加Padding
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                    color: isSelected ? const Color(0xFFF4D743) : Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: kIsWeb
            ? [Color(0xFF00B2FF)]
            : [
                Color(0xFF00B2FF),
                Color(0xFFCCEAFF),
                Color(0xFF0075FF),
              ],
        stops: kIsWeb
            ? [1.0]
            : [
                0.0,
                0.5,
                1.0,
              ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
