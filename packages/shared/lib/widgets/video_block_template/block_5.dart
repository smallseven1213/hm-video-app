import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

import '../base_video_preview.dart';

class Block5Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;
  final Widget? buildFooter;

  const Block5Widget(
      {Key? key,
      required this.block,
      required this.updateBlock,
      required this.channelId,
      required this.film,
      required this.buildVideoPreview,
      this.buildFooter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vod> videos = block.videos?.data ?? [];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:
                  (MediaQuery.of(context).size.width - 16) / 2.5 / 16 * 9 + 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    videos.length,
                    (index) => Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      width: (MediaQuery.of(context).size.width - 16) / 2.5,
                      child: buildVideoPreview(videos[index]),
                    ),
                  ),
                ),
              ),
            ),
            buildFooter ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
