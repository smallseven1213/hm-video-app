import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';

import 'base_video_block_templates/template_10.dart';
import 'base_video_block_templates/template_2.dart';
import 'base_video_block_templates/template_3.dart';
import 'base_video_block_templates/template_4.dart';

final Map<int,
        SliverChildDelegate Function(List<Vod> vods, int areaId, {int? film})>
    templateMap = {
  2: (List<Vod> vods, int areaId, {int? film = 1}) =>
      baseVideoBlockTemplate2(vods: vods, film: film, areaId: areaId),
  3: (List<Vod> vods, int areaId, {int? film = 1}) =>
      baseVideoBlockTemplate3(vods: vods, film: film, areaId: areaId),
  4: (List<Vod> vods, int areaId, {int? film = 1}) =>
      baseVideoBlockTemplate4(vods: vods, film: film, areaId: areaId),
  10: (List<Vod> vods, int areaId, {int? film = 1}) =>
      baseVideoBlockTemplate10(vods: vods, film: film, areaId: areaId),
};

class BaseVideoBlockTemplate extends StatelessWidget {
  final int templateId;
  final List<Vod> vods;
  final int? film;
  final int areaId;
  const BaseVideoBlockTemplate(
      {Key? key,
      required this.areaId,
      required this.templateId,
      required this.vods,
      this.film = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final findTemplate = templateMap[templateId];
    if (findTemplate != null) {
      return SliverList(delegate: findTemplate(vods, areaId, film: film));
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
