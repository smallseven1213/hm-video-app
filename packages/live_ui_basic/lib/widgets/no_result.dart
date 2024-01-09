import 'package:flutter/material.dart';

class NoResult extends StatelessWidget {
  const NoResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 100),
        Image(
          image: AssetImage('assets/images/ic_noresult.webp'),
          width: 48,
          height: 48,
        ),
        SizedBox(height: 8),
        Text(
          '這裡什麼都沒有',
          style: TextStyle(color: Color(0xff6f6f79)),
        ),
      ],
    );
  }
}
