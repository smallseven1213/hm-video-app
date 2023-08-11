import 'package:shared/widgets/base_video_preview.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/index.dart';

import '../video_block_grid_view.dart';
import '../video_block_grid_view_row.dart';

final logger = Logger();

List<List<Vod>> organizeRowData(List videos) {
  List<List<Vod>> resultArray = [];
  List<Vod> tempArray = [];

  for (int i = 0; i < videos.length; i++) {
    tempArray.add(videos[i]);
    bool hasAreaAd = videos[i].dataType == VideoType.areaAd.index;

    if (hasAreaAd) {
      resultArray.add(tempArray);
      tempArray = [];
    } else if (tempArray.length == 3) {
      resultArray.add(tempArray);
      tempArray = [];
    }
  }

  if (tempArray.isNotEmpty) {
    resultArray.add(tempArray);
  }

  return resultArray;
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
    List<List<Vod>> result = organizeRowData(videos);
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == result.length) {
              return buildFooter ?? const SizedBox.shrink();
            }
            return SizedBox(
              child: result[index][0].dataType == VideoType.areaAd.index
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: buildBanner(result[index][0]),
                    )
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
            );
          },
          childCount: result.length + 1,
        ),
      ),
    );
  }
}
