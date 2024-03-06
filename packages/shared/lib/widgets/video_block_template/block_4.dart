import 'package:shared/widgets/base_video_preview.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/index.dart';

import '../video_block_grid_view_row.dart';

final logger = Logger();

List<List<Vod>> organizeRowData(List videos, Blocks block) {
  List<List<Vod>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int videoWithoutAdLength =
      videos.where((video) => video.dataType == 1).toList().length;
  int videoLength =
      videoWithoutAdLength > blockQuantity ? blockQuantity : videos.length;

  for (int i = 0; i < videoLength;) {
    if (i != 0 && i == videos.length - 1) break;
    bool hasAreaAd = videos[i].dataType == VideoType.areaAd.index;
    try {
      if (hasAreaAd) {
        result.add([videos[i]]);
        i++;
      } else if (i + 2 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1], videos[i + 2]]);
        i += 3;
        // logger.i('Block1Widget 有3筆: $i');
      } else if (i + 1 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1], Vod(0, '')]);
        i += 2;
        // logger.i('Block1Widget 有2筆: $i');
      } else {
        // 落單的一筆
        if (i < videos.length) {
          result.add([videos[i], Vod(0, ''), Vod(0, '')]);
          i++;
          // logger.i('Block1Widget 落單的一筆: $i');
        } else {
          break;
        }
      }
    } catch (e) {
      logger.i('err: $e');
    }
  }
  return result;
}

// 六直小
class Block4Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;
  final Widget Function(Vod video) buildBanner;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;
  final Widget? buildFooter;

  const Block4Widget(
      {Key? key,
      required this.block,
      required this.updateBlock,
      required this.channelId,
      required this.film,
      required this.buildBanner,
      required this.buildVideoPreview,
      this.buildFooter})
      : super(key: key);

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
              // padding bottom 8
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                child: result[index][0].dataType == VideoType.areaAd.index
                    ? buildBanner(result[index][0])
                    : VideoBlockGridViewRow(
                        videoData: result[index],
                        imageRatio: BlockImageRatio.block4.ratio,
                        isEmbeddedAds: block.isEmbeddedAds ?? false,
                        gridLength: 3,
                        displayCoverVertical: true,
                        blockId: block.id ?? 0,
                        film: film,
                        displayVideoCollectTimes: false,
                        displayVideoTimes: false,
                        displayViewTimes: false,
                        hasInfoView: false,
                        buildVideoPreview: buildVideoPreview,
                      ),
              ),
            );
          },
          childCount: result.length + 1,
        ),
      ),
    );
  }
}
