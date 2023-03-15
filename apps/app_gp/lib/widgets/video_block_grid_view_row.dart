import 'package:app_gp/screens/main_screen/layout_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

import 'video_preview.dart';

class VideoBlockGridViewRow extends StatelessWidget {
  final List<Data> videoData;

  VideoBlockGridViewRow({required this.videoData});

  @override
  Widget build(BuildContext context) {
    logger.i('~~~~~VideoBlockGridViewRow~~~~~\n${videoData.toString()}');
    // if videoData lenght is 1, push empty container
    if (videoData.length == 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: VideoPreviewWidget(
              title: videoData[0].title ?? '精彩好片',
              tags: videoData[0].tags ?? [],
              timeLength: videoData[0].timeLength ?? 0,
              coverHorizontal: videoData[0].coverHorizontal ?? '',
              coverVertical: videoData[0].coverVertical ?? '',
              videoViewTimes: videoData[0].videoViewTimes ?? 0,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: SizedBox(
              height: 200,
              width: double.infinity,
            ),
          ),
        ],
      );
    }
    return Row(
      children: videoData
          .expand(
            (e) => [
              Expanded(
                child: VideoPreviewWidget(
                  title: e.title ?? '精彩好片',
                  tags: e.tags ?? [],
                  timeLength: e.timeLength ?? 0,
                  coverHorizontal: e.coverHorizontal ?? '',
                  coverVertical: e.coverVertical ?? '',
                  videoViewTimes: e.videoViewTimes ?? 0,
                ),
              ),
              const SizedBox(width: 10),
            ],
          )
          .toList()
        ..removeLast(),
    );
  }
}
