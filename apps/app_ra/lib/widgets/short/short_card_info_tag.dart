import 'package:flutter/material.dart';

class ShortCardInfoTag extends StatelessWidget {
  const ShortCardInfoTag({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
          fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
