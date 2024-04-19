import 'package:flutter/material.dart';
import 'package:shared/models/block_image_ratio.dart';
import 'package:shared/models/vod.dart';
import '../../models/game.dart';
import '../base_video_preview.dart';
import '../game_block_template/game_cards.dart';
import '../video_block_grid_view_row.dart';

List<List<Vod>> organizeRowData(List<Vod> videos) {
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

SliverChildBuilderDelegate baseVideoBlockTemplate4({
  required List<Vod> vods,
  int? film = 1,
  required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
  required Widget Function(Vod video) buildBanner,
  required int areaId,
  List<Game>? gameBlocks,
}) {
  List<List<Vod>> organizedData = organizeRowData(vods);
  int rowsBetweenGames = 2; // Every 6 rows, insert a GameArea
  int gameAreaCounter = 0; // Counter to keep track of gameBlocks insertion

  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      int numberOfGameAreasInserted = (index / (rowsBetweenGames + 1)).floor();
      bool isGameArea = (index % (rowsBetweenGames + 1) == rowsBetweenGames) &&
          index != 0 &&
          gameBlocks != null &&
          gameBlocks.isNotEmpty;

      if (isGameArea) {
        int counter = ((index) / 3).floor();
        Game currentGame = gameBlocks[counter % gameBlocks.length];
        return GameCardWidget(game: currentGame);
      } else {
        int adjustedIndex = index - numberOfGameAreasInserted;
        if (adjustedIndex < organizedData.length) {
          List<Vod> rowData = organizedData[adjustedIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: rowData[0].dataType == VideoType.areaAd.index
                ? buildBanner(rowData[0])
                : VideoBlockGridViewRow(
                    videoData: rowData,
                    gridLength: 3,
                    imageRatio: BlockImageRatio.block4.ratio,
                    isEmbeddedAds: true,
                    displayCoverVertical: true,
                    film: film,
                    blockId: areaId,
                    displayVideoCollectTimes: false,
                    displayVideoTimes: false,
                    displayViewTimes: false,
                    buildVideoPreview: buildVideoPreview),
          );
        }
      }
      return const SizedBox
          .shrink(); // Fallback to an empty widget for edge cases
    },
    childCount: organizedData.length +
        ((organizedData.length / rowsBetweenGames).floor() *
            (gameBlocks != null && gameBlocks.isNotEmpty ? 1 : 0)),
  );
}
