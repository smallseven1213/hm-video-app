import 'package:flutter/material.dart';

class ListNoMore extends StatelessWidget {
  const ListNoMore({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Center(
            child: SizedBox(
                height: 100,
                child: Text(
                  '没有更多影片了',
                  style: TextStyle(color: Colors.white),
                ))));
  }
}
