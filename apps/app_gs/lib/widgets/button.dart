import 'package:flutter/material.dart';

const buttonPadding = {
  'small': EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  'medium': EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  'large': EdgeInsets.symmetric(horizontal: 30, vertical: 15),
};

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final dynamic icon; // GlowingIcon or Icon
  final String? type; // primary, secondary
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.white),
          color: type == 'primary'
              ? const Color.fromRGBO(255, 255, 255, 0.8)
              : const Color.fromRGBO(66, 119, 220, 0.5)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
            clipBehavior: Clip.antiAlias,
            padding: buttonPadding[size],
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: type == 'primary'
                      ? const Color(0xFF4277DC)
                      : const Color.fromRGBO(18, 18, 69, 0.5),
                  blurRadius: 20,
                  spreadRadius: type == 'primary' ? 0 : -10,
                ),
              ],
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
                      color: Colors.white,
                      fontSize: size == 'small' ? 14 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
