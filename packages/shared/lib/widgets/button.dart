import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

const buttonPadding = {
  'small': EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  'medium': EdgeInsets.symmetric(horizontal: 0, vertical: 8),
  'large': EdgeInsets.symmetric(horizontal: 10, vertical: 10),
};

Map buttonBg = {
  'primary': Color(0xff6874b6),
  'secondary': Color(0xff3F425A),
  'cancel': Color(0xff1F2235),
};

Map buttonText = {
  'primary': Colors.white,
  'secondary': Colors.white,
  'cancel': Colors.white,
};

class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.transparent
      ..shader = null;
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
                      color: buttonText[type],
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

Button buttonBuilder({
  required String text,
  required VoidCallback onPressed,
  dynamic icon,
  String? type = 'primary',
  String? size = 'medium',
}) {
  return Button(
    text: text,
    onPressed: onPressed,
    icon: icon,
    type: type,
    size: size,
  );
}
