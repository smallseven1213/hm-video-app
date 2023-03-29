import 'package:app_gp/widgets/channel_area_banner.dart';
import 'package:app_gp/widgets/video_block_footer.dart';
import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

// 四大
class Block2Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  const Block2Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> videos = block.videos?.data ?? [];

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == videos.length) {
              return VideoBlockFooter(
                  block: block, updateBlock: updateBlock, channelId: channelId);
            }

            return Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: videos[index].dataType == VideoType.areaAd.index
                  ? ChannelAreaBanner(
                      image: BannerImage.fromJson({
                        'id': videos[index].id ?? 0,
                        'url': videos[index].adUrl ?? '',
                        'photoSid': videos[index].coverHorizontal ?? '',
                        'isAutoClose': false,
                      }),
                    )
                  : VideoPreviewWidget(
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
            );
          },
          childCount: videos.length + 1, // 额外的1用于 VideoBlockFooter
        ),
      ),
    );
  }
}
