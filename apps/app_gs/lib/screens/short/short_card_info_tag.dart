import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShortCardInfoTag extends StatelessWidget {
  const ShortCardInfoTag({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: kIsWeb
          ? null
          : BoxDecoration(
              color: const Color.fromRGBO(66, 119, 220, 0.5),
              borderRadius: BorderRadius.circular(100),
            ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
