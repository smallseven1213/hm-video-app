import 'package:app_wl_id1/widgets/no_data.dart';
import 'package:app_wl_id1/widgets/sliver_video_preview_skelton_list.dart';
import 'package:app_wl_id1/widgets/video_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SliverVodGrid extends StatefulWidget {
  final int? film;
  final List videos;
  final bool displayNoMoreData;
  final bool isListEmpty;
  final bool displayLoading;
  final Widget? noMoreWidget;
  final List<Widget>? headerExtends;
  final Function? onScrollEnd;
  final bool? displayVideoFavoriteTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;
  final bool? displayCoverVertical;
  final bool? hasTags;
  final ScrollController? customScrollController;
  final Function(int id)? onOverrideRedirectTap;
  final int? insertWidgetInterval; // 每幾個column插入一個widget
  final Widget? insertWidget;

  const SliverVodGrid(
      {Key? key,
      this.film = 1,
      required this.videos,
      required this.displayNoMoreData,
      required this.isListEmpty,
      required this.displayLoading,
      this.insertWidgetInterval = 0,
      this.insertWidget,
      this.onOverrideRedirectTap,
      this.noMoreWidget,
      this.headerExtends,
      this.onScrollEnd,
      this.hasTags = true,
      this.displayCoverVertical = false,
      this.displayVideoFavoriteTimes = true,
      this.displayVideoTimes = true,
      this.displayViewTimes = true,
      this.customScrollController})
      : super(key: key);

  @override
  SliverVodGridState createState() => SliverVodGridState();
}

class SliverVodGridState extends State<SliverVodGrid> {
  @override
  Widget build(BuildContext context) {
    try {
      if (widget.videos.isEmpty) {
        return CustomScrollView(
          slivers: [
            ...?widget.headerExtends,
            const SliverToBoxAdapter(child: NoDataWidget()),
          ],
        );
      }

      int totalRows = (widget.videos.length / 2).ceil();
      int childCount = totalRows;

      if (widget.insertWidgetInterval != null &&
          widget.insertWidgetInterval! > 0) {
        childCount += (totalRows / widget.insertWidgetInterval!).ceil();
      }

      return CustomScrollView(
        physics: kIsWeb ? null : const BouncingScrollPhysics(),
        controller: widget.customScrollController,
        scrollBehavior:
            ScrollConfiguration.of(context).copyWith(scrollbars: false),
        slivers: [
          ...?widget.headerExtends,
          if (widget.isListEmpty)
            const SliverToBoxAdapter(child: NoDataWidget()),
          if (totalRows > 0)
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index >= childCount) return null; // 額外的安全檢查

                    // 檢查是否需要插入 widget
                    if (widget.insertWidgetInterval != null &&
                        widget.insertWidgetInterval! > 0 &&
                        index % (widget.insertWidgetInterval! + 1) ==
                            widget.insertWidgetInterval) {
                      return widget.insertWidget ?? const SizedBox.shrink();
                    }

                    // 調整索引以考慮插入的 widget
                    int actualIndex = index - (index ~/ 9);
                    int firstVideoIndex = actualIndex * 2;
                    int secondVideoIndex = firstVideoIndex + 1;

                    return buildVideoRow(firstVideoIndex, secondVideoIndex);
                  },
                  childCount: childCount,
                ),
              ),
            ),
          if (widget.displayLoading) const SliverVideoPreviewSkeletonList(),
          if (widget.displayNoMoreData)
            SliverToBoxAdapter(
              child: widget.noMoreWidget,
            ),
        ],
      );
    } catch (e) {
      print('Error in SliverVodGrid build: $e');
      return const SliverToBoxAdapter(child: Text('An error occurred'));
    }
  }

  Widget buildVideoRow(int firstVideoIndex, int secondVideoIndex) {
    try {
      Widget firstVideoWidget = const SizedBox.shrink();
      Widget secondVideoWidget = const SizedBox.shrink();

      if (firstVideoIndex < widget.videos.length) {
        var firstVideo = widget.videos[firstVideoIndex];
        firstVideoWidget = VideoPreviewWidget(
          id: firstVideo.id,
          film: widget.film,
          hasTags: widget.hasTags,
          displayCoverVertical: widget.displayCoverVertical ?? false,
          coverVertical: firstVideo.coverVertical,
          coverHorizontal: firstVideo.coverHorizontal,
          timeLength: firstVideo.timeLength,
          tags: firstVideo.tags,
          title: firstVideo.title,
          videoViewTimes: firstVideo.videoViewTimes,
          videoFavoriteTimes: firstVideo.videoFavoriteTimes,
          displayVideoFavoriteTimes: widget.displayVideoFavoriteTimes,
          displayVideoTimes: widget.displayVideoTimes,
          displayViewTimes: widget.displayViewTimes,
          onOverrideRedirectTap: widget.onOverrideRedirectTap,
        );
      }

      if (secondVideoIndex < widget.videos.length) {
        var secondVideo = widget.videos[secondVideoIndex];
        secondVideoWidget = VideoPreviewWidget(
          id: secondVideo.id,
          film: widget.film,
          hasTags: widget.hasTags,
          displayCoverVertical: widget.displayCoverVertical ?? false,
          coverVertical: secondVideo.coverVertical,
          coverHorizontal: secondVideo.coverHorizontal,
          timeLength: secondVideo.timeLength,
          tags: secondVideo.tags,
          title: secondVideo.title,
          videoViewTimes: secondVideo.videoViewTimes,
          videoFavoriteTimes: secondVideo.videoFavoriteTimes,
          displayVideoFavoriteTimes: widget.displayVideoFavoriteTimes,
          displayVideoTimes: widget.displayVideoTimes,
          displayViewTimes: widget.displayViewTimes,
          onOverrideRedirectTap: widget.onOverrideRedirectTap,
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: firstVideoWidget),
              const SizedBox(width: 8),
              Expanded(child: secondVideoWidget),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
    } catch (e) {
      print('Error building video row: $e');
      return const SizedBox.shrink();
    }
  }
}
