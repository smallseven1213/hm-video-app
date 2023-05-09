import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channe_block_vod_controller.dart';

import '../../../widgets/base_video_block_template.dart';

final logger = Logger();

class Vods extends StatelessWidget {
  final ScrollController? scrollController;
  final int areaId;
  final int? templateId;

  const Vods({
    Key? key,
    this.scrollController,
    required this.areaId,
    this.templateId = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vodController = Get.put(
        ChannelBlockVodController(
          areaId: areaId,
          scrollController: ScrollController(),
        ),
        tag: '$areaId');

    return Obx(() => CustomScrollView(
          controller: vodController.scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: BaseVideoBlockTemplate(
                templateId: templateId ?? 3,
                vods: vodController.vodList.value,
              ),
            ),
          ],
        ));
  }
}
