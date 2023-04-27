import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class BannerAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.orange,
      child: Center(child: Text('廣告 Banner', style: TextStyle(fontSize: 24))),
    );
  }
}
