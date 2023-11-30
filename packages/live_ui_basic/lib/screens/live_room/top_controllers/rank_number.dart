import 'package:flutter/material.dart';

class RankNumber extends StatelessWidget {
  final int number;

  const RankNumber({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 8,
      color: Colors.transparent,
      child: Stack(
        children: [
          if (number == 1)
            Image.asset('packages/live_ui_basic/assets/images/rank_no1.webp',
                width: 13, height: 8),
          if (number == 2)
            Image.asset('packages/live_ui_basic/assets/images/rank_no2.webp',
                width: 13, height: 8),
          if (number == 3)
            Image.asset('packages/live_ui_basic/assets/images/rank_no3.webp',
                width: 13, height: 8),
          Center(
            child: Text(
              number < 4 ? number.toString() : "0${number.toString()}",
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
