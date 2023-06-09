import 'dart:async';

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
  final bool isActive;

  const Vods({
    Key? key,
    required this.areaId,
    this.templateId = 3,
    this.isActive = false,
  }) : super(key: key);

  @override
  VodsState createState() => VodsState();
}

class VodsState extends State<Vods> {
  ScrollController? _scrollController;
  ChannelBlockVodController? vodController;
  Timer? _debounceTimer;

  void _scrollListener() {
    if (_scrollController!.position.pixels ==
        _scrollController!.position.maxScrollExtent) {
      debounce(
        fn: () {
          vodController!.loadMoreData();
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = PrimaryScrollController.of(context);
    _scrollController!.addListener(_scrollListener);

    vodController ??= ChannelBlockVodController(
      areaId: widget.areaId,
      scrollController: _scrollController!,
      autoDisposeScrollController: false,
      hasLoadMoreEventWithScroller: false,
    );
  }

  @override
  void didUpdateWidget(covariant Vods oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _scrollController?.addListener(_scrollListener);
      } else {
        _scrollController?.removeListener(_scrollListener);
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    vodController?.dispose();
    _scrollController?.removeListener(_scrollListener);
    // _scrollController?.dispose();
    super.dispose();
  }

  void debounce({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  @override
  Widget build(BuildContext context) {
    if (vodController == null) {
      // The controller is not ready yet.
      return const SizedBox();
    }
    return Obx(
      () {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: BaseVideoBlockTemplate(
                film: vodController!.film.value,
                templateId: widget.templateId ?? 3,
                areaId: widget.areaId,
                vods: vodController!.vodList.value,
              ),
            ),
            if (vodController!.hasMoreData.value)
              const SliverVideoPreviewSkeletonList(),
            if (!vodController!.hasMoreData.value)
              SliverToBoxAdapter(
                child: ListNoMore(),
              )
          ],
        );
      },
    );
  }
}
