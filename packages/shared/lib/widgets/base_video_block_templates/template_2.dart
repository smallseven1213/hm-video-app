import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import '../../models/game.dart';
import '../base_video_preview.dart';
import '../game_block_template/game_area.dart';

// Configurable to adjust the game block frequency.
const int defaultRowsBetweenGames = 10;

SliverChildBuilderDelegate baseVideoBlockTemplate2({
  required List<Vod> vods,
  required int areaId,
  required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
  required Widget Function(Vod video) buildBanner,
  int? film = 1,
  List<Game>? gameBlocks,
}) {
  // int totalVideoRows = vods.length;
  // int totalGameInsertions = gameBlocks != null && gameBlocks.isNotEmpty
  //     ? (totalVideoRows / defaultRowsBetweenGames).floor()
  //     : 0;

  // bool isGameArea(int index) {
  //   return index % (defaultRowsBetweenGames + 1) == defaultRowsBetweenGames &&
  //       gameBlocks != null &&
  //       gameBlocks.isNotEmpty;
  // }

  return SliverChildBuilderDelegate((BuildContext context, int index) {
    Vod video = vods[index];
    int gameBlockIndex = (index ~/ 10);
    if (gameBlocks == null || gameBlocks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: video.dataType == VideoType.areaAd.index
            ? buildBanner(video)
            : buildVideoPreview(video),
      );
    }
    Game currentGame = gameBlocks![gameBlockIndex % gameBlocks.length];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: video.dataType == VideoType.areaAd.index
          ? Column(
              children: [
                buildBanner(video),
                if ((index + 1) % 10 == 0) ...[
                  const SizedBox(height: 8),
                  GameArea(game: currentGame),
                ]
              ],
            )
          : buildVideoPreview(video),
    );
    // if (isGameArea(index)) {
    //   int gameBlockIndex = (index ~/ (defaultRowsBetweenGames + 1));
    //   Game currentGame = gameBlocks![gameBlockIndex % gameBlocks.length];
    //   return GameArea(game: currentGame);
    // } else {
    //   if (index < totalVideoRows) {
    //     Vod video = vods[index];
    //     print('video.id: ${video.id}');
    //     return Padding(
    //       padding: const EdgeInsets.only(bottom: 8.0),
    //       child: video.dataType == VideoType.areaAd.index
    //           ? buildBanner(video)
    //           : buildVideoPreview(video),
    //     );
    //   }
    // }
  }, childCount: vods.length
      // childCount: totalVideoRows + totalGameInsertions,
      );
}
