// Block6Widget

import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

class Block6Widget extends StatelessWidget {
  final Blocks block;
  const Block6Widget({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> videos = block.videos?.data ?? [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Row(
          children: List.generate(
            videos.length,
            (index) => Container(
              padding: const EdgeInsets.only(right: 8.0),
              width: (MediaQuery.of(context).size.width - 16) * 0.7,
              height:
                  (MediaQuery.of(context).size.width - 16) * 0.7 / 16 * 9 + 40,
              child: VideoPreviewWidget(
                title: videos[index].title ?? '',
                tags: videos[index].tags ?? [],
                timeLength: videos[index].timeLength ?? 0,
                coverHorizontal: videos[index].coverHorizontal ?? '',
                coverVertical: videos[index].coverVertical ?? '',
                videoViewTimes: videos[index].videoViewTimes ?? 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
