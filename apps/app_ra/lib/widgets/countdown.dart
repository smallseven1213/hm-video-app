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
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          widget.countdownSeconds == 0
              ? '立即進入'
              : '倒數 ${widget.countdownSeconds.toString()}S',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
