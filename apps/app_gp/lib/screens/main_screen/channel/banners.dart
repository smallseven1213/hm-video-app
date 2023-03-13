// Banners

import 'package:flutter/material.dart';

class Banners extends StatelessWidget {
  final int channelId;
  const Banners({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            height: 200,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
