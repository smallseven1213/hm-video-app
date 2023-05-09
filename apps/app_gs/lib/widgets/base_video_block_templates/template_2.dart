// class Template3 is a stateless widget, only has props: List<Vod> vods

import 'package:flutter/material.dart';
import 'package:shared/models/block_image_ratio.dart';
import 'package:shared/models/vod.dart';

import '../video_block_grid_view_row.dart';
import '../video_preview.dart';

SliverChildBuilderDelegate baseVideoBlockTemplate2({
  required List<Vod> vods,
}) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      var video = vods[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: VideoPreviewWidget(
          id: video.id,
          title: video.title,
          tags: video.tags ?? [],
          timeLength: video.timeLength ?? 0,
          coverHorizontal: video.coverHorizontal ?? '',
          coverVertical: video.coverVertical ?? '',
          videoViewTimes: video.videoViewTimes ?? 0,
          detail: video,
        ),
      );
    },
    childCount: vods.length,
  );
}
