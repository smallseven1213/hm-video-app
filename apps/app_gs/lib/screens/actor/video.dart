import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_video_preview_skelton_list.dart';
import '../../widgets/video_preview.dart';

class ActorVideoScreen extends StatelessWidget {
  final int id;
  final String type;
  final ScrollController scrollController;
  final vodController;
  ActorVideoScreen({
    Key? key,
    required this.type,
    required this.id,
    required this.scrollController,
    required this.vodController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScrollView(
          // controller: scrollController, // Use the shared ScrollController
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverAlignedGrid.count(
                crossAxisCount: 2,
                itemCount: vodController.vodList.length,
                itemBuilder: (BuildContext context, int index) {
                  var video = vodController.vodList[index];
                  return VideoPreviewWidget(
                      id: video.id,
                      coverVertical: video.coverVertical!,
                      coverHorizontal: video.coverHorizontal!,
                      timeLength: video.timeLength!,
                      tags: video.tags!,
                      title: video.title,
                      videoViewTimes: video.videoViewTimes!);
                },
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 10.0,
              ),
            ),
            if (vodController.hasMoreData)
              const SliverVideoPreviewSkeletonList(),
            if (!vodController.hasMoreData)
              const SliverToBoxAdapter(
                child: ListNoMore(),
              )
          ],
        ));
  }
}
