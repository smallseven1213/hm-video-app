import 'package:flutter/material.dart';

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
            ? const Color.fromARGB(255, 161, 184, 226)
            : const Color(0xff1E50B1),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
            clipBehavior: Clip.antiAlias,
            padding: size == 'medium'
                ? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.5)
                : null,
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
                      fontSize: size == 'medium' ? 16 : 14,
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
