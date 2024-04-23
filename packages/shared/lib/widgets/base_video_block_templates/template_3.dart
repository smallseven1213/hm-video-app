import 'package:flutter/material.dart';
import 'package:shared/models/block_image_ratio.dart';
import 'package:shared/models/vod.dart';
import '../../models/game.dart';
import '../base_video_preview.dart';
import '../game_block_template/game_cards.dart';
import '../video_block_grid_view_row.dart';

// Constants to define behavior
const int videosPerRow = 2;
const int defaultRowsBetweenGames = 6;

// Helper function to organize VODs into rows based on certain conditions.
List<List<Vod>> organizeRowData(List<Vod> videos, int maxVideosPerRow) {
  List<List<Vod>> resultArray = [];
  List<Vod> tempArray = [];
  for (var video in videos) {
    tempArray.add(video);
    if (video.dataType == VideoType.areaAd.index ||
        tempArray.length == maxVideosPerRow) {
      resultArray.add(List.from(tempArray));
      tempArray.clear();
    }
  }
  if (tempArray.isNotEmpty) {
    resultArray.add(tempArray);
  }
  return resultArray;
}

SliverChildBuilderDelegate baseVideoBlockTemplate3({
  required List<Vod> vods,
  int? film = 1,
  required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
  required Widget Function(Vod video) buildBanner,
  required int areaId,
  List<Game>? gameBlocks,
}) {
  bool containsAd =
      vods.any((video) => video.dataType == VideoType.areaAd.index);
  bool containsGame = gameBlocks != null && gameBlocks.isNotEmpty;
  int rowsBetweenGames =
      containsAd ? defaultRowsBetweenGames + 2 : defaultRowsBetweenGames;

  List<List<Vod>> organizedData = organizeRowData(vods, videosPerRow);
  int totalRows = organizedData.length;

  int gameBlockInsertions =
      containsGame ? (totalRows / rowsBetweenGames).floor() : 0;
  int childCount = totalRows + gameBlockInsertions;

  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      int gameAreasBeforeIndex =
          containsGame ? (index / (rowsBetweenGames + 1)).floor() : 0;
      bool isGameArea =
          containsGame && index % (rowsBetweenGames + 1) == rowsBetweenGames;

      if (isGameArea) {
        int gameIndex = gameAreasBeforeIndex % gameBlocks.length;
        return GameCardWidget(game: gameBlocks[gameIndex]);
      } else {
        int adjustedIndex = index - gameAreasBeforeIndex;
        if (adjustedIndex < organizedData.length) {
          List<Vod> rowData = organizedData[adjustedIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: rowData[0].dataType == VideoType.areaAd.index
                ? buildBanner(rowData[0])
                : VideoBlockGridViewRow(
                    videoData: rowData,
                    gridLength: videosPerRow,
                    imageRatio: BlockImageRatio.block3.ratio,
                    isEmbeddedAds: true,
                    film: film,
                    blockId: areaId,
                    displayVideoCollectTimes: false,
                    buildVideoPreview: buildVideoPreview,
                  ),
          );
        }
      }
      return const SizedBox
          .shrink(); // Fallback to an empty widget for edge cases
    },
    childCount: childCount,
  );
}
