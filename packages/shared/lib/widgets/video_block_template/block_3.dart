import 'package:shared/widgets/base_video_preview.dart';
import 'package:shared/widgets/video_block_grid_view_row.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

List<List<Vod>> organizeRowData(List videos, Blocks block) {
  List<List<Vod>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int videoWithoutAdLength =
      videos.where((video) => video.dataType == 1).toList().length;
  int videoLength =
      videoWithoutAdLength > blockQuantity ? blockQuantity : videos.length;

  try {
    for (int i = 0; i < videoLength;) {
      if (i != 0 && i == videos.length) break;
      bool hasAreaAd = videos[i].dataType == VideoType.areaAd.index;
      if (hasAreaAd) {
        // 廣告那一筆
        result.add([videos[i]]);
        // logger.i('Block1Widget 廣告變成一筆: $i');
        i++;
      } else if (i + 1 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1]]);
        i += 2;
        // logger.i('Block1Widget 有兩筆: $i');
      } else {
        // 落單的一筆
        result.add([videos[i]]);
        i++;
      }
    }
  } catch (e) {
    logger.i('Block1Widget error: $e');
    return [];
  }
  return result;
}

// 六小
class Block3Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;
  final Widget Function(Vod video) buildBanner;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;
  final Widget? buildFooter;
  const Block3Widget({
    Key? key,
    required this.film,
    required this.block,
    required this.updateBlock,
    required this.channelId,
    required this.buildBanner,
    required this.buildVideoPreview,
    this.buildFooter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vod> videos = block.videos?.data ?? [];
    List<List<Vod>> result = organizeRowData(videos, block);

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == result.length) {
              return buildFooter ?? const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                child: result[index][0].dataType == VideoType.areaAd.index
                    ? buildBanner(result[index][0])
                    : VideoBlockGridViewRow(
                        videoData: result[index],
                        imageRatio: BlockImageRatio.block3.ratio,
                        isEmbeddedAds: block.isEmbeddedAds ?? false,
                        buildVideoPreview: buildVideoPreview),
              ),
            );
          },
          childCount: result.length + 1, // 额外的1用于 VideoBlockFooter
        ),
      ),
    );
  }
}
