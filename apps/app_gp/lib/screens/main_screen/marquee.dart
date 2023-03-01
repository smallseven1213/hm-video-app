import 'package:flutter/material.dart';

class Marquee extends StatelessWidget {
  const Marquee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
