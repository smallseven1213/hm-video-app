import 'package:flutter/material.dart';

class ShortCardInfoTag extends StatelessWidget {
  const ShortCardInfoTag({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        shadows: [
          Shadow(
            offset: Offset(0, 2), // Horizontal and Vertical offset
            blurRadius: 4.0, // Amount of blur
            color:
                Color.fromARGB(128, 0, 0, 0), // Color with 50% (0.5) opacity
          ),
        ],
      ),
    );
  }
}
