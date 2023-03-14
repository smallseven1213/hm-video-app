// Block1Widget

import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

class Block1Widget extends StatelessWidget {
  List<Data> videos = [];
  Block1Widget({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          10,
          (index) => VideoPreviewWidget(
            title: videos[index].title ?? '',
            tags: videos[index].tags ?? [],
            timeLength: videos[index].timeLength ?? 0,
            coverHorizontal: videos[index].coverHorizontal ?? '',
            coverVertical: videos[index].coverVertical ?? '',
            videoViewTimes: videos[index].videoViewTimes ?? 0,
          ),
        ));
  }
}
