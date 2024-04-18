import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import '../../models/game.dart';
import '../base_video_preview.dart';
import '../game_block_template/vertical_game_card.dart';

SliverChildBuilderDelegate baseVideoBlockTemplate2({
  required List<Vod> vods,
  required int areaId,
  required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
  required Widget Function(Vod video) buildBanner,
  List<Game>? gameBlocks,
  int? film = 1,
}) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      if (index == 0) {
        // 首個元素是影音區塊
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: buildVideoPreview(vods[0]),
        );
      } else if ((index - 1) % 8 == 0) {
        // 每 8 個影片後出現一個 VerticalGameCard
        // return const VerticalGameCard();
      } else {
        // 其他情況則是一般的影片
        var video = vods[(index - 1) % vods.length];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: video.dataType == VideoType.areaAd.index
              ? buildBanner(video)
              : buildVideoPreview(video),
        );
      }
    },
    childCount: vods.length + (vods.length ~/ 8),
  );
}
