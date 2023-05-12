import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channe_block_vod_controller.dart';

import '../../../widgets/base_video_block_template.dart';

final logger = Logger();

class Vods extends StatefulWidget {
  final ScrollController scrollController;
  final int areaId;
  final int? templateId;

  const Vods({
    Key? key,
    required this.scrollController,
    required this.areaId,
    this.templateId = 3,
  }) : super(key: key);

  @override
  VodsState createState() => VodsState();
}

class VodsState extends State<Vods> {
  @override
  Widget build(BuildContext context) {
    final vodController = Get.put(
        ChannelBlockVodController(
          areaId: widget.areaId,
          scrollController: widget.scrollController,
        ),
        tag: '${widget.areaId}');

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification ||
            scrollNotification is ScrollUpdateNotification) {
          widget.scrollController.jumpTo(vodController.scrollController.offset);
        }
        return false;
      },
      child: Obx(
        () => CustomScrollView(
          controller: vodController.scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: BaseVideoBlockTemplate(
                templateId: widget.templateId ?? 3,
                vods: vodController.vodList.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
