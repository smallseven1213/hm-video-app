import 'package:flutter/material.dart';

const buttonPadding = {
  'small': EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  'medium': EdgeInsets.symmetric(horizontal: 0, vertical: 8),
  'large': EdgeInsets.symmetric(horizontal: 10, vertical: 10),
};

const buttonBg = {
  'primary': Color(0xFFfe2c55),
  'secondary': Color(0xFF1345a5),
  'cancel': Color(0xffdedede),
};

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
