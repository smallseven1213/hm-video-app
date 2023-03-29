// // Block6Widget
import 'package:app_gp/widgets/video_block_footer.dart';
import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

// 六小
class Block6Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  const Block6Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> videos = block.videos?.data ?? [];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:
                  (MediaQuery.of(context).size.width - 16) * 0.7 / 16 * 9 + 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    videos.length,
                    (index) => Container(
                      padding: const EdgeInsets.only(right: 8.0),
                      width: (MediaQuery.of(context).size.width - 16) * 0.7,
                      child: VideoPreviewWidget(
                        id: videos[index].id!,
                        title: videos[index].title ?? '',
                        tags: videos[index].tags ?? [],
                        timeLength: videos[index].timeLength ?? 0,
                        coverHorizontal: videos[index].coverHorizontal ?? '',
                        coverVertical: videos[index].coverVertical ?? '',
                        videoViewTimes: videos[index].videoViewTimes ?? 0,
                        detail: videos[index],
                        isEmbeddedAds: block.isEmbeddedAds ?? false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            VideoBlockFooter(
                block: block, updateBlock: updateBlock, channelId: channelId),
          ],
        ),
      ),
    );
  }
}
