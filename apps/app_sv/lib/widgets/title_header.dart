import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  const TitleHeader({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          height: 15,
          width: 2,
          color: Colors.red,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }
}
