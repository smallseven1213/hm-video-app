import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/widgets/grid_silver_fix_size_delegate.dart';

import '../../../../widgets/video_block_grid_view.dart';

// 一大多小
class Block1Widget extends StatelessWidget {
  List<Data> videos = [];
  Block1Widget({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 除了第0個的物件
    List<Data> videosFromSecond = videos.sublist(1);
    // 取得this.videos的第一個物件
    Data videoFromFirst = videos[0];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          VideoPreviewWidget(
            title: videoFromFirst.title ?? '',
            tags: videoFromFirst.tags ?? [],
            timeLength: videoFromFirst.timeLength ?? 0,
            coverHorizontal: videoFromFirst.coverHorizontal ?? '',
            coverVertical: videoFromFirst.coverVertical ?? '',
            videoViewTimes: videoFromFirst.videoViewTimes ?? 0,
            imageRatio: 374 / 198,
          ),
          const SizedBox(height: 10),
          VideoBlockGridView(videos: videosFromSecond),
        ],
      ),
    );
  }
}
