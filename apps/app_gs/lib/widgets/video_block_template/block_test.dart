import 'dart:math';

import 'package:flutter/material.dart';

class BlockTest extends StatelessWidget {
  final Key? key;

  const BlockTest({required this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 随机生成高度在50到300之间
          final randomHeight = Random().nextInt(251) + 50;

          // 随机生成颜色
          final randomColor = Color.fromARGB(
            255,
            Random().nextInt(256),
            Random().nextInt(256),
            Random().nextInt(256),
          );

          return Container(
            height: randomHeight.toDouble(),
            color: randomColor,
            child: Center(
              child: Text('Item $index'),
            ),
          );
        },
        childCount: 100000,
      ),
    );
  }
}
