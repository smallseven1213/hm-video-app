import 'package:flutter/material.dart';

class GameLoading extends StatelessWidget {
  const GameLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 2.0,
      color: Color.fromARGB(208, 255, 255, 255),
    );
  }
}
