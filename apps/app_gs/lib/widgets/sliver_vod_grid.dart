import 'package:app_gs/widgets/sliver_video_preview_skelton_list.dart';
import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliverVodGrid extends StatelessWidget {
  final List videos;
  final bool hasMoreData;
  final Widget? noMoreWidget;
  final List<Widget>? headerExtends;
  final ScrollController? scrollController;

  const SliverVodGrid({
    Key? key,
    required this.videos,
    required this.hasMoreData,
    this.noMoreWidget,
    this.scrollController,
    this.headerExtends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int totalRows = (videos.length / 2).ceil();
      return CustomScrollView(
        controller: scrollController,
        slivers: [
          ...?headerExtends,
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  int firstVideoIndex = index * 2;
                  int secondVideoIndex = firstVideoIndex + 1;

                  var firstVideo = videos[firstVideoIndex];
                  var secondVideo = secondVideoIndex < videos.length
                      ? videos[secondVideoIndex]
                      : null;

                  // logger.i('RENDER SLIVER VOD GRID');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: VideoPreviewWidget(
                              id: firstVideo.id,
                              coverVertical: firstVideo.coverVertical!,
                              coverHorizontal: firstVideo.coverHorizontal!,
                              timeLength: firstVideo.timeLength!,
                              tags: firstVideo.tags!,
                              title: firstVideo.title,
                              videoViewTimes: firstVideo.videoViewTimes!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: secondVideo != null
                                  ? VideoPreviewWidget(
                                      id: secondVideo.id,
                                      coverVertical: secondVideo.coverVertical!,
                                      coverHorizontal:
                                          secondVideo.coverHorizontal!,
                                      timeLength: secondVideo.timeLength!,
                                      tags: secondVideo.tags!,
                                      title: secondVideo.title,
                                      videoViewTimes:
                                          secondVideo.videoViewTimes!,
                                    )
                                  : const SizedBox.shrink()),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
                childCount: totalRows,
              ),
            ),
          ),
          if (hasMoreData) const SliverVideoPreviewSkeletonList(),
          if (!hasMoreData && noMoreWidget != null)
            SliverToBoxAdapter(
              child: noMoreWidget,
            ),
        ],
      );
    });
  }
}
