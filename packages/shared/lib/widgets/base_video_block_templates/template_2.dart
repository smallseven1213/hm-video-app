import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import '../../models/game.dart';
import '../base_video_preview.dart';
import '../game_block_template/game_cards.dart';

// Configurable to adjust the game block frequency.
const int rowsBetweenGames = 8;

SliverChildBuilderDelegate baseVideoBlockTemplate2({
  required List<Vod> vods,
  required int areaId,
  required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
  required Widget Function(Vod video) buildBanner,
  int? film = 1,
  List<Game>? gameBlocks,
}) {
  int totalVideoRows = vods.length;
  int totalGameInsertions = gameBlocks != null && gameBlocks.isNotEmpty
      ? (totalVideoRows / rowsBetweenGames).floor()
      : 0;

  bool isGameArea(int index) {
    return index % (rowsBetweenGames + 1) == rowsBetweenGames &&
        gameBlocks != null &&
        gameBlocks.isNotEmpty;
  }

  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      if (isGameArea(index)) {
        int gameBlockIndex = (index ~/ (rowsBetweenGames + 1));
        Game currentGame = gameBlocks![gameBlockIndex % gameBlocks.length];
        return GameCardWidget(game: currentGame);
      } else {
        if (index < totalVideoRows) {
          Vod video = vods[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: video.dataType == VideoType.areaAd.index
                ? buildBanner(video)
                : buildVideoPreview(video),
          );
        }
      }
      return const SizedBox.shrink(); // For out of range indices
    },
    childCount: totalVideoRows + totalGameInsertions,
  );
}
