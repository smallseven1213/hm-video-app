import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/publisher_hottest_vod_controller.dart';
import 'package:shared/controllers/publisher_latest_vod_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_video_preview_skelton_list.dart';
import '../../widgets/video_preview.dart';

class VendorVideoList extends StatelessWidget {
  final String type;
  final int publisherId;
  final scrollController = ScrollController();
  VendorVideoList({Key? key, required this.type, required this.publisherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publisherVodController = type == 'hot'
        ? PublisherHottestVodController(
            publisherId: publisherId, scrollController: scrollController)
        : PublisherLatestVodController(
            publisherId: publisherId, scrollController: scrollController);

    return Obx(() => CustomScrollView(
          controller: publisherVodController.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverAlignedGrid.count(
                crossAxisCount: 2,
                itemCount: publisherVodController.vodList.length,
                itemBuilder: (BuildContext context, int index) {
                  var video = publisherVodController.vodList[index];
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
            if (publisherVodController.hasMoreData)
              const SliverVideoPreviewSkeletonList(),
            if (!publisherVodController.hasMoreData)
              const SliverToBoxAdapter(
                child: ListNoMore(),
              )
          ],
        ));
  }
}
