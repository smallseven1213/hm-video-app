import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/widgets/grid_silver_fix_size_delegate.dart';

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

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: VideoPreviewWidget(
            title: videoFromFirst.title ?? '',
            tags: videoFromFirst.tags ?? [],
            timeLength: videoFromFirst.timeLength ?? 0,
            coverHorizontal: videoFromFirst.coverHorizontal ?? '',
            coverVertical: videoFromFirst.coverVertical ?? '',
            videoViewTimes: videoFromFirst.videoViewTimes ?? 0,
          ),
        ),
        GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 182 / 160,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: List.generate(
              videosFromSecond.length,
              (index) => VideoPreviewWidget(
                  title: videosFromSecond[index].title ?? '',
                  tags: videosFromSecond[index].tags ?? [],
                  timeLength: videosFromSecond[index].timeLength ?? 0,
                  coverHorizontal:
                      videosFromSecond[index].coverHorizontal ?? '',
                  coverVertical: videosFromSecond[index].coverVertical ?? '',
                  videoViewTimes: videosFromSecond[index].videoViewTimes ?? 0,
                  imageRatio: 101.93 / 182),
            ))
      ],
    );
  }
}
