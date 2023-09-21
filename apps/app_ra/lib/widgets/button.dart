import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const buttonPadding = {
  'small': EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  'medium': EdgeInsets.symmetric(horizontal: 0, vertical: 8),
  'large': EdgeInsets.symmetric(horizontal: 10, vertical: 10),
};

const buttonBg = {
  'primary': Colors.transparent,
  'secondary': Color(0xFF273262),
  'cancel': Colors.transparent,
  'disabled': Colors.transparent,
};

final defaultBorderColor = {
  'primary': Colors.white,
  'secondary': const Color(0xffFDDCEF),
  'cancel': Colors.white,
  'disabled': Colors.white.withOpacity(0.3),
};

final defaultTextColor = {
  'primary': Colors.white,
  'secondary': const Color(0xffFDDCEF),
  'cancel': Colors.white,
  'disabled': Colors.white.withOpacity(0.3),
};

class Button extends StatelessWidget {
  final String text;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  final dynamic icon; // GlowingIcon or Icon
  final String? type; // primary, secondary, cancel, disabled
  final String? size; // small, medium, large

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
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
          borderRadius: BorderRadius.circular(25),
          color: backgroundColor ?? buttonBg[type],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CustomPaint(
          child: Container(
            padding: buttonPadding[size],
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor ?? defaultBorderColor[type] ?? Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? defaultTextColor[type],
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
