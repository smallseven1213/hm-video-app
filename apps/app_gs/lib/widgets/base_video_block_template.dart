import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';

import 'base_video_block_templates/template_10.dart';
import 'base_video_block_templates/template_2.dart';
import 'base_video_block_templates/template_3.dart';
import 'base_video_block_templates/template_4.dart';

final Map<int, SliverChildDelegate Function(List<Vod> vods)> templateMap = {
  2: (List<Vod> vods) => baseVideoBlockTemplate2(vods: vods),
  3: (List<Vod> vods) => baseVideoBlockTemplate3(vods: vods),
  4: (List<Vod> vods) => baseVideoBlockTemplate4(vods: vods),
  10: (List<Vod> vods) => baseVideoBlockTemplate10(vods: vods),
};

class BaseVideoBlockTemplate extends StatelessWidget {
  final int templateId;
  final List<Vod> vods;
  const BaseVideoBlockTemplate(
      {Key? key, required this.templateId, required this.vods})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final findTemplate = templateMap[templateId];
    if (findTemplate != null) {
      return SliverList(delegate: findTemplate(vods));
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
