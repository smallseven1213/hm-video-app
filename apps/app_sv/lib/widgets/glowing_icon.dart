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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: color,
        size: size,
      ),
    );
  }
}
