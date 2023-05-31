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
  ScrollController? _scrollController;
  late ChannelBlockVodController vodController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollController == null) {
      _scrollController = PrimaryScrollController.of(context);
      vodController = Get.put(
          ChannelBlockVodController(
            areaId: widget.areaId,
            scrollController: _scrollController!,
            autoDisposeScrollController: false,
            hasLoadMoreEventWithScroller: false,
          ),
          tag: '${widget.areaId}');

      _scrollController!.addListener(() {
        if (_scrollController!.position.pixels ==
            _scrollController!.position.maxScrollExtent) {
          logger.i('到底了');
          vodController!.loadMoreData();
        }
      });
    }
  }

  @override
  void dispose() {
    // _scrollController!.dispose();
    // 這裡scroller是父層共用的，不要隨便dispose
    Get.delete<ChannelBlockVodController>(tag: '${widget.areaId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return CustomScrollView(
          controller: _scrollController,
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
