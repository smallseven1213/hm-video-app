import 'dart:math';

import 'package:app_gp/widgets/channel_area_banner.dart';
import 'package:app_gp/widgets/video_block_footer.dart';
import 'package:app_gp/widgets/video_block_grid_view_row.dart';
import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

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
