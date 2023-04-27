import 'package:app_gs/screens/video/video_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/block_videos_by_category_controller.dart';
import 'package:shared/models/vod.dart';

import 'enums.dart';

class RelatedVideos extends StatelessWidget {
  final TabController tabController;
  final Vod videoDetail;

  const RelatedVideos({
    super.key,
    required this.tabController,
    required this.videoDetail,
  });

  String getIdList(List inputList) {
    if (inputList.isEmpty) return '';
    return inputList.take(3).map((e) => e.id.toString()).join(',');
  }

  @override
  Widget build(BuildContext context) {
    final BlockVideosByCategoryController blockVideosController = Get.put(
      BlockVideosByCategoryController(
        tagId: getIdList(videoDetail.tags!),
        actorId: videoDetail.actors!.isEmpty
            ? ''
            : videoDetail.actors![0].id.toString(),
        excludeId: videoDetail.id.toString(),
        internalTagId: videoDetail.internalTagIds!.join(',').toString(),
      ),
      tag: DateTime.now().toString(),
    );

    return Obx(
      () {
        return TabBarView(
          controller: tabController,
          children: [
            VideoList(
              videos: blockVideosController.videoByActor.value,
              tabController: tabController,
              category: VideoFilterType.actor,
            ),
            VideoList(
              videos: blockVideosController.videoByTag.value,
              tabController: tabController,
              category: VideoFilterType.category,
            ),
            VideoList(
              videos: blockVideosController.videoByInternalTag.value,
              tabController: tabController,
              category: VideoFilterType.tag,
            ),
            // SliverAlignGrid
          ],
        );
      },
    );
  }
}