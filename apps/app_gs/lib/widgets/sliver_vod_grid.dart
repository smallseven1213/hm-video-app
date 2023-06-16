import 'package:app_gs/widgets/no_data.dart';
import 'package:app_gs/widgets/sliver_video_preview_skelton_list.dart';
import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliverVodGrid extends StatelessWidget {
  final List videos;
  final bool displayNoMoreData;
  final bool isListEmpty;
  final bool displayLoading;
  final Widget? noMoreWidget;
  final List<Widget>? headerExtends;
  final Function? onScrollEnd;
  final bool? usePrimaryParentScrollController;
  final ScrollController? customScrollController;
  final bool? displayVideoCollectTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;

  const SliverVodGrid(
      {Key? key,
      required this.videos,
      required this.displayNoMoreData,
      required this.isListEmpty,
      required this.displayLoading,
      this.noMoreWidget,
      this.headerExtends,
      this.onScrollEnd,
      this.usePrimaryParentScrollController = false,
      this.displayVideoCollectTimes = true,
      this.displayVideoTimes = true,
      this.displayViewTimes = true,
      this.customScrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController =
        customScrollController ?? ScrollController();
    if (usePrimaryParentScrollController == true) {
      scrollController = PrimaryScrollController.of(context);
    }

    if (onScrollEnd != null) {
      scrollController.addListener(() {
        logger.i(
            'sliver $key => position.pixels ${scrollController.position.pixels} position.maxScrollExtent ${scrollController.position.maxScrollExtent}');
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          logger.i('到底了');
          if (onScrollEnd != null) {
            onScrollEnd!();
          }
        }
      });
    }

    return Obx(() {
      int totalRows = (videos.length / 2).ceil();
      logger.i('totalRows $totalRows');

      return CustomScrollView(
        controller: scrollController,
        slivers: [
          ...?headerExtends,
          if (isListEmpty)
            const SliverToBoxAdapter(
              child: NoDataWidget(),
            ),
          if (totalRows > 0)
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
                                videoCollectTimes:
                                    firstVideo.videoCollectTimes!,
                                displayVideoCollectTimes:
                                    displayVideoCollectTimes,
                                displayVideoTimes: displayVideoTimes,
                                displayViewTimes: displayViewTimes,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: secondVideo != null
                                    ? VideoPreviewWidget(
                                        id: secondVideo.id,
                                        coverVertical:
                                            secondVideo.coverVertical!,
                                        coverHorizontal:
                                            secondVideo.coverHorizontal!,
                                        timeLength: secondVideo.timeLength!,
                                        tags: secondVideo.tags!,
                                        title: secondVideo.title,
                                        videoViewTimes:
                                            secondVideo.videoViewTimes!,
                                        videoCollectTimes:
                                            secondVideo.videoCollectTimes!,
                                        displayVideoCollectTimes:
                                            displayVideoCollectTimes,
                                        displayVideoTimes: displayVideoTimes,
                                        displayViewTimes: displayViewTimes,
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
          // ignore: prefer_const_constructors
          if (displayLoading) SliverVideoPreviewSkeletonList(),
          if (displayNoMoreData)
            SliverToBoxAdapter(
              child: noMoreWidget,
            ),
        ],
      );
    });
  }
}
