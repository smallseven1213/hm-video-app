import 'package:app_gs/widgets/no_data.dart';
import 'package:app_gs/widgets/sliver_video_preview_skelton_list.dart';
import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliverVodGrid extends StatefulWidget {
  final int? film;
  final List videos;
  final bool displayNoMoreData;
  final bool isListEmpty;
  final bool displayLoading;
  final Widget? noMoreWidget;
  final List<Widget>? headerExtends;
  final Function? onScrollEnd;
  final bool? displayVideoCollectTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;
  final bool? displayCoverVertical;
  final ScrollController? customScrollController;
  final Function(int id)? onOverrideRedirectTap;

  const SliverVodGrid({
    Key? key,
    this.film = 1,
    required this.videos,
    required this.displayNoMoreData,
    required this.isListEmpty,
    required this.displayLoading,
    this.onOverrideRedirectTap,
    this.noMoreWidget,
    this.headerExtends,
    this.onScrollEnd,
    this.displayCoverVertical = false,
    this.displayVideoCollectTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.customScrollController,
  }) : super(key: key);

  @override
  SliverVodGridState createState() => SliverVodGridState();
}

class SliverVodGridState extends State<SliverVodGrid> {
  @override
  Widget build(BuildContext context) {
    int totalRows = (widget.videos.length / 2).ceil();

    return CustomScrollView(
      physics: kIsWeb ? null : const BouncingScrollPhysics(),
      controller: widget.customScrollController,
      scrollBehavior:
          ScrollConfiguration.of(context).copyWith(scrollbars: false),
      slivers: [
        ...?widget.headerExtends,
        if (widget.isListEmpty)
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

                  var firstVideo = widget.videos[firstVideoIndex];
                  var secondVideo = secondVideoIndex < widget.videos.length
                      ? widget.videos[secondVideoIndex]
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
                              film: widget.film,
                              displayCoverVertical:
                                  widget.displayCoverVertical ?? false,
                              coverVertical: firstVideo.coverVertical!,
                              coverHorizontal: firstVideo.coverHorizontal!,
                              timeLength: firstVideo.timeLength!,
                              tags: firstVideo.tags!,
                              title: firstVideo.title,
                              videoViewTimes: firstVideo.videoViewTimes!,
                              videoCollectTimes: firstVideo.videoCollectTimes!,
                              displayVideoCollectTimes:
                                  widget.displayVideoCollectTimes,
                              displayVideoTimes: widget.displayVideoTimes,
                              displayViewTimes: widget.displayViewTimes,
                              onOverrideRedirectTap:
                                  widget.onOverrideRedirectTap,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: secondVideo != null
                                  ? VideoPreviewWidget(
                                      id: secondVideo.id,
                                      film: widget.film,
                                      displayCoverVertical:
                                          widget.displayCoverVertical ?? false,
                                      coverVertical: secondVideo.coverVertical!,
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
                                          widget.displayVideoCollectTimes,
                                      displayVideoTimes:
                                          widget.displayVideoTimes,
                                      displayViewTimes: widget.displayViewTimes,
                                      onOverrideRedirectTap:
                                          widget.onOverrideRedirectTap,
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
        if (widget.displayLoading) SliverVideoPreviewSkeletonList(),
        if (widget.displayNoMoreData)
          SliverToBoxAdapter(
            child: widget.noMoreWidget,
          ),
      ],
    );
  }
}
