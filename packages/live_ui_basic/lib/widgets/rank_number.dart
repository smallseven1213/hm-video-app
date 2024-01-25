import 'package:flutter/material.dart';

class RankNumber extends StatelessWidget {
  final int number;
  // add width and height
  final double? width;
  final double? height;

  const RankNumber({
    super.key,
    required this.number,
    this.width = 13,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.transparent,
      child: Stack(
        children: [
          if (number == 1)
            Image.asset('packages/live_ui_basic/assets/images/rank_no1.webp',
                width: width, height: height),
          if (number == 2)
            Image.asset('packages/live_ui_basic/assets/images/rank_no2.webp',
                width: width, height: height),
          if (number == 3)
            Image.asset('packages/live_ui_basic/assets/images/rank_no3.webp',
                width: width, height: height),
          Center(
            child: Text(
              number < 4 ? number.toString() : "0${number.toString()}",
              style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
