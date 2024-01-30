import 'package:app_wl_cn1/widgets/video_preview_style_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'no_data.dart';
import 'sliver_video_preview_skelton_list.dart';

class SliverVodList extends StatefulWidget {
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

  const SliverVodList({
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
  SliverVodListState createState() => SliverVodListState();
}

class SliverVodListState extends State<SliverVodList> {
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
                (BuildContext context, int index) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VideoPreviewStyle2Widget(
                      id: widget.videos[index].id,
                      film: widget.film,
                      displayCoverVertical:
                          widget.displayCoverVertical ?? false,
                      coverVertical: widget.videos[index].coverVertical!,
                      coverHorizontal: widget.videos[index].coverHorizontal!,
                      timeLength: widget.videos[index].timeLength!,
                      tags: widget.videos[index].tags!,
                      title: widget.videos[index].title,
                      videoViewTimes: widget.videos[index].videoViewTimes!,
                      videoCollectTimes:
                          widget.videos[index].videoCollectTimes!,
                      displayVideoCollectTimes: widget.displayVideoCollectTimes,
                      displayVideoTimes: widget.displayVideoTimes,
                      displayViewTimes: widget.displayViewTimes,
                      onOverrideRedirectTap: widget.onOverrideRedirectTap,
                      displayPublisher: widget.videos[index].publisher != null,
                      publisherName: widget.videos[index].publisher != null
                          ? widget.videos[index].publisher!.name
                          : '',
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
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
