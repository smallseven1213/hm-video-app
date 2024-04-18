import 'package:flutter/material.dart';
import 'package:shared/models/block_image_ratio.dart';
import 'package:shared/models/vod.dart';

import '../../models/game.dart';
import '../base_video_preview.dart';
import '../game_block_template/cross_column_game_card.dart';
import '../game_block_template/horizontal_game_card.dart';
import '../game_block_template/vertical_game_card.dart';
import '../video_block_grid_view_row.dart';

List<List<Vod>> organizeRowData(List videos) {
  List<List<Vod>> resultArray = [];
  List<Vod> tempArray = [];

  for (int i = 0; i < videos.length; i++) {
    tempArray.add(videos[i]);
    bool hasAreaAd = videos[i].dataType == VideoType.areaAd.index;

    if (hasAreaAd) {
      resultArray.add(tempArray);
      tempArray = [];
    } else if (tempArray.length == 2) {
      resultArray.add(tempArray);
      tempArray = [];
    }
  }

  if (tempArray.isNotEmpty) {
    resultArray.add(tempArray);
  }

  return resultArray;
}

int itemCount = 6; // 每6行视频显示一次HorizontalGameCard

SliverChildBuilderDelegate baseVideoBlockTemplate10({
  required List<Vod> vods,
  required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
  required Widget Function(Vod video) buildBanner,
  required int areaId,
  List<Game>? gameBlocks,
  int? film = 1,
}) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      int adjustedIndex = index;
      int numOfBanners = (adjustedIndex / (itemCount + 1))
          .floor(); // 计算需要插入多少个HorizontalGameCard
      bool isBannerRow = (index % (itemCount + 1) == itemCount);
      print('>>> baseVideoBlockTemplate4 3個小封面');
      print('>>> buildGameBlock: $gameBlocks');

      if (isBannerRow) {
        // return const HorizontalGameCard();
      } else {
        adjustedIndex -= numOfBanners; // 调整index以跳过HorizontalGameCard
        List<List<Vod>> result = organizeRowData(vods);

        if (adjustedIndex < result.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: result[adjustedIndex][0].dataType == VideoType.areaAd.index
                ? buildBanner(result[adjustedIndex][0])
                : VideoBlockGridViewRow(
                    videoData: result[adjustedIndex],
                    gridLength: 2,
                    imageRatio: BlockImageRatio.block10.ratio,
                    isEmbeddedAds: true,
                    displayCoverVertical: true,
                    film: film,
                    blockId: areaId,
                    displayVideoCollectTimes: false,
                    displayVideoTimes: true,
                    displayViewTimes: true,
                    buildVideoPreview: buildVideoPreview),
          );
        }
      }
      return null;
    },
    // childCount 计算方法调整，考虑到了插入的HorizontalGameCard
    childCount: (vods.length / 2 + (vods.length / 2) / itemCount).ceil(),
  );
}
