import 'package:flutter/material.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

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
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1),
            duration: const Duration(milliseconds: 5000),
            builder: (context, value, _) => CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 4,
              value: value,
            ),
          ),
        ),
        Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(60),
          ),
          child: Text(
            widget.countdownSeconds == 0 ? I18n.enter : '${widget.countdownSeconds}S',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
