import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const buttonPadding = {
  'small': EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  'medium': EdgeInsets.symmetric(horizontal: 0, vertical: 8),
  'large': EdgeInsets.symmetric(horizontal: 10, vertical: 10),
};

const buttonBg = {
  'primary': Color.fromRGBO(19, 69, 165, 0.4),
  'secondary': Color(0xFF1345a5),
  'cancel': Color(0xff06275e),
};

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
      ..strokeWidth = 2.0
      ..color = const Color(0xFF00b2ff)
      ..shader = kIsWeb ? null : gradient.createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4.0)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final dynamic icon; // GlowingIcon or Icon
  final String? type; // primary, secondary, cancel
  final String? size; // small, medium, large

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.type = 'primary',
    this.size = 'medium',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: buttonBg[type],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CustomPaint(
          painter: type == 'cancel' ? null : _GradientBorderPainter(),
          child: Container(
            padding: buttonPadding[size],
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: type == 'cancel'
                          ? const Color(0xffb2bac5)
                          : Colors.white,
                      fontSize: size == 'small' ? 12 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
