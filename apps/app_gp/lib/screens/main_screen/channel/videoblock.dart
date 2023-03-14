import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

import 'video_block_template/block_1.dart';
import 'video_block_template/block_2.dart';

final Map<int, Widget Function(List<Data>)> blockMap = {
  0: (List<Data> videos) => const SizedBox(),
  1: (List<Data> videos) => Block1Widget(
        videos: videos,
      ),
  2: (List<Data> videos) => Block2Widget(
        videos: videos,
      ),
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
          Container(
            // padding x 10
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(block.name ?? '',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
          blockMap[block.template ?? 0] == null
              ? const SizedBox()
              : blockMap[block.template ?? 0]!(block.videos?.data ?? []),

          // ...?block.videos?.data
          //     ?.map((e) => Container(
          //           child: Text(e.title ?? '--'),
          //         ))
          //     .toList(),
        ],
      ),
    );
  }
}
