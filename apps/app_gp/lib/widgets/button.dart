import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final Icon? icon;
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
            ? const Color(0xff1E50B1)
            : const Color(0xFFFFFFFF),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: size == 'medium'
              ? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.5)
              : const EdgeInsets.all(20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: type == 'primary'
                    ? const Color.fromRGBO(18, 18, 69, 0.5)
                    : const Color(0xFF4277DC),
                blurRadius: 20,
                spreadRadius: type == 'primary' ? -10 : 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
