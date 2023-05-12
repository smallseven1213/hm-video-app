import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class TagWidget extends StatelessWidget {
  final int id;
  final String name;

  const TagWidget({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        MyRouteDelegate.of(context)
            .push(AppRoutes.tag.value, args: {'id': id, 'title': name});
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomPaint(
          painter: _GradientBorderPainter(),
          child: Center(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
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
    final Rect rect = Offset.zero & size;
    const Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF00b2ff),
        Color(0xFFcceaff),
        Color(0xFF0075ff),
      ],
    );
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10.0)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
