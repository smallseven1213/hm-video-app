import 'package:flutter/material.dart';

class GameTag extends StatelessWidget {
  final String text;
  final Color textColor;

  const GameTag({
    Key? key,
    required this.text,
    this.textColor = const Color(0xFF21A8F8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(right: 10),
      height: 14,
      decoration: const BoxDecoration(
        color: Color(0xFF21488E),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}
