import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

import '../base_video_preview.dart';

// 四大
class Block2Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;
  final Widget Function(Vod video) buildBanner;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;
  final Widget? buildFooter;
  const Block2Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
    required this.film,
    required this.buildBanner,
    required this.buildVideoPreview,
    this.buildFooter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vod> videos = block.videos?.data ?? [];

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == videos.length) {
              return buildFooter ?? const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: videos[index].dataType == VideoType.areaAd.index
                  ? buildBanner(videos[index])
                  : buildVideoPreview(videos[index]),
            );
          },
          childCount: videos.length + 1, // 额外的1用于 VideoBlockFooter
        ),
      ),
    );
  }
}
