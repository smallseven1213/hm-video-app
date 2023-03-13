import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;
  final String type;

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = 'primary',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: type == 'primary'
                  ? const Color(0xff1E50B1)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: type == 'primary'
                      ? const Color.fromRGBO(18, 18, 69, 0.5)
                      : const Color(0xFF4277DC),
                  blurRadius: 20,
                  spreadRadius: type == 'primary' ? -10 : 0,
                ),
              ],
              border: Border.all(width: 1, color: Colors.white),
            ),
            child: Center(
              child: text,
            ),
          ),
        ],
      ),
    );
  }
}
