import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';

import '../models/game.dart';
import 'base_video_block_templates/template_10.dart';
import 'base_video_block_templates/template_2.dart';
import 'base_video_block_templates/template_3.dart';
import 'base_video_block_templates/template_4.dart';
import 'base_video_preview.dart';

final Map<
    int,
    SliverChildDelegate Function({
      required List<Vod> vods,
      required int areaId,
      required BaseVideoPreviewWidget Function(Vod video) buildVideoPreview,
      required Widget Function(Vod video) buildBanner,
      List<Game>? gameBlocks,
      int? film,
    })> templateMap = {
  2: baseVideoBlockTemplate2, // 單個影片
  3: baseVideoBlockTemplate3, // 橫板 2
  4: baseVideoBlockTemplate4, // 豎版 3
  10: baseVideoBlockTemplate10, // 豎版 2
};

class BaseVideoBlockTemplate extends StatelessWidget {
  final int templateId;
  final List<Vod> vods;
  final int? film;
  final int areaId;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;
  final Widget Function(Vod video) buildBanner;
  final List<Game>? gameBlocks;

  const BaseVideoBlockTemplate({
    Key? key,
    required this.areaId,
    required this.templateId,
    required this.vods,
    required this.buildVideoPreview,
    required this.buildBanner,
    this.gameBlocks,
    this.film = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final findTemplate = templateMap[templateId];
    if (findTemplate != null) {
      return SliverList(
        delegate: findTemplate(
          vods: vods,
          gameBlocks: gameBlocks,
          areaId: areaId,
          film: film,
          buildBanner: buildBanner,
          buildVideoPreview: buildVideoPreview,
        ),
      );
    }
    return SliverToBoxAdapter(
        child: Center(
      child: Text(
        'Template $templateId not found',
        style: const TextStyle(color: Colors.white),
      ),
    ));
  }
}
