import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

import '../../../widgets/header.dart';
import 'video_block_template/block_1.dart';
import 'video_block_template/block_2.dart';
import 'video_block_template/block_3.dart';
import 'video_block_template/block_4.dart';

final Map<int, Widget Function(Blocks block)> blockMap = {
  0: (Blocks block) => const SizedBox(),
  1: (Blocks block) => Block1Widget(block: block),
  2: (Blocks block) => Block2Widget(block: block),
  3: (Blocks block) => Block3Widget(block: block),
  4: (Blocks block) => Block4Widget(block: block),
};

class VideoBlock extends StatelessWidget {
  final Blocks block;
  const VideoBlock({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            text: '${block.name} [${block.template}]',
          ),
          const SizedBox(
            height: 5,
          ),
          blockMap[block.template ?? 0] == null
              ? const SizedBox()
              : blockMap[block.template ?? 0]!(block),
        ],
      ),
    );
  }
}
