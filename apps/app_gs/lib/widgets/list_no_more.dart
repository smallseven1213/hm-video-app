import 'package:flutter/material.dart';

class ListNoMore extends StatelessWidget {
  const ListNoMore({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 60, bottom: 60 + MediaQuery.of(context).padding.bottom),
        child: const Center(
            child: SizedBox(
                height: 100,
                child: Text(
                  '没有更多影片了',
                  style: TextStyle(color: Colors.white),
                ))));
  }
}
