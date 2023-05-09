// class Template3 is a stateless widget, only has props: List<Vod> vods

import 'package:flutter/material.dart';
import 'package:shared/models/block_image_ratio.dart';
import 'package:shared/models/vod.dart';

import '../video_block_grid_view_row.dart';

SliverChildBuilderDelegate baseVideoBlockTemplate4({
  required List<Vod> vods,
}) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      // 每2個vods組成一個videos
      var videos = vods.sublist(index * 2, index * 2 + 2);
      return Padding(
        // padding bottom 8
        padding: const EdgeInsets.only(bottom: 8.0),
        child: VideoBlockGridViewRow(
          videoData: videos,
          gridLength: 3,
          imageRatio: BlockImageRatio.block4.ratio,
          isEmbeddedAds: false,
        ),
      );
    },
    childCount: vods.length ~/ 2,
  );
}
