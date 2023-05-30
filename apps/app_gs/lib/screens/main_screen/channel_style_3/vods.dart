import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channe_block_vod_controller.dart';

import '../../../widgets/base_video_block_template.dart';
import '../../../widgets/list_no_more.dart';
import '../../../widgets/sliver_video_preview_skelton_list.dart';

final logger = Logger();

class Vods extends StatefulWidget {
  final int areaId;
  final int? templateId;

  const Vods({
    Key? key,
    required this.areaId,
    this.templateId = 3,
  }) : super(key: key);

  @override
  VodsState createState() => VodsState();
}

class VodsState extends State<Vods> {
  @override
  Widget build(BuildContext context) {
    var scrollController = PrimaryScrollController.of(context);
    var vodController = Get.put(
        ChannelBlockVodController(
          areaId: widget.areaId,
          scrollController: scrollController,
        ),
        tag: '${widget.areaId}');

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        logger.i('到底了');
        vodController.loadMoreData();
      }
    });
    return Obx(
      () {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: BaseVideoBlockTemplate(
                film: vodController.film.value,
                templateId: widget.templateId ?? 3,
                areaId: widget.areaId,
                vods: vodController.vodList.value,
              ),
            ),
            if (vodController.hasMoreData.value)
              const SliverVideoPreviewSkeletonList(),
            if (!vodController.hasMoreData.value)
              const SliverToBoxAdapter(
                child: ListNoMore(),
              )
          ],
        );
      },
    );
  }
}
