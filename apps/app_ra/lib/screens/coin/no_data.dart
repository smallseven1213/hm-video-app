import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/images/ic_no_list.png'),
          fit: BoxFit.fill,
        ),
        SizedBox(height: 20),
        Text(
          '沒有更多記錄',
          style: TextStyle(
            fontSize: 12,
            height: .5,
            color: Color(0xFF6B6B6B),
          ),
        ),
      ],
    ));
  }
}
