import 'package:flutter/material.dart';

class GlowingIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double size;

  const GlowingIcon({
    Key? key,
    required this.iconData,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        iconData,
        color: color,
        size: size,
      ),
    );
  }
}
