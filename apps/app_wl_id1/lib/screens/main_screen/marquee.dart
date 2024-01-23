import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../../config/colors.dart';

class Marquee extends StatelessWidget {
  const Marquee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppColors.colors[ColorKeys.background],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          return Text('item $index');
        },
      ),
    );
  }
}
