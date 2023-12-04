import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Resize extends StatelessWidget {
  const Resize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return Container(
        //       padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
        //       child: Resizes(),
        //     );
        //   },
        // );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/resize_button.webp',
          width: 33,
          height: 33),
    );
  }
}
