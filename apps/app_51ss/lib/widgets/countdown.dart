import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final int countdownSeconds;
  const Countdown({Key? key, required this.countdownSeconds}) : super(key: key);

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          width: 1.8,
          color: Colors.white,
        ),
      ),
      child: Text(
        widget.countdownSeconds == 0 ? '進入' : '${widget.countdownSeconds}S',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
