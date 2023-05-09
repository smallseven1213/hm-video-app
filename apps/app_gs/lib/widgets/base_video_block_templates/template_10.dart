// class Template3 is a stateless widget, only has props: List<Vod> vods

import 'package:flutter/material.dart';
import 'package:shared/models/block_image_ratio.dart';
import 'package:shared/models/vod.dart';

import '../video_block_grid_view_row.dart';

class BaseVideoBlockTemplate10 extends StatelessWidget {
  final List<Vod> vods;

  const BaseVideoBlockTemplate10({
    Key? key,
    required this.vods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        // 每2個vods組成一個videos
        var videos = vods.sublist(index * 2, index * 2 + 2);
        return Padding(
          // padding bottom 8
          padding: const EdgeInsets.only(bottom: 8.0),
          child: VideoBlockGridViewRow(
            videoData: videos,
            gridLength: 2,
            imageRatio: BlockImageRatio.block10.ratio,
            isEmbeddedAds: false,
          ),
        );
      },
      childCount: vods.length ~/ 2,
    ));
  }
}
