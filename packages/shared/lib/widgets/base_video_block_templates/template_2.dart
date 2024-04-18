import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';

import '../../models/game.dart';
import '../base_video_preview.dart';

SliverChildBuilderDelegate baseVideoBlockTemplate2({
  required List<Vod> vods,
  required int areaId,
  required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
  required Widget Function(Vod video) buildBanner,
  int? film = 1,
  List<Game>? gameBlocks,
}) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      var video = vods[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: video.dataType == VideoType.areaAd.index
            ? buildBanner(video)
            : buildVideoPreview(video),
      );
    },
    childCount: vods.length,
  );
}
