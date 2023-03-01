import 'package:flutter/material.dart';

class ShortScreen extends StatelessWidget {
  const ShortScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shorts'),
      ),
      body: ListView.builder(
        itemCount: 500,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/video');
              },
              child: Text('Video $index'),
            ),
          );
        },
      ),
    );
  }
}
