import 'package:flutter/material.dart';

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return Container(
        //       padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
        //       child: Mores(),
        //     );
        //   },
        // );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/more_button.webp',
          width: 33,
          height: 33),
    );
  }
}
