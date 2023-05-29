// // Block6Widget
import 'package:app_gs/widgets/video_block_footer.dart';
import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/vod.dart';

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
    List<Vod> videos = block.videos?.data ?? [];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        videoCollectTimes: videos[index].videoCollectTimes ?? 0,
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
