import 'package:flutter/material.dart';

class ShortScreen extends StatelessWidget {
  const ShortScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shorts'),
      ),
      body: Center(
        child: Text('Shorts'),
      ),
    );
  }
}
