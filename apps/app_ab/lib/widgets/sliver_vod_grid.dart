import 'package:app_ab/widgets/sliver_video_preview_skelton_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

import 'no_data.dart';
import 'video_preview.dart';

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
  final ScrollController? customScrollController;
  final Function(int id)? onOverrideRedirectTap;
  final double? padding;
  final bool displayAds; // 是否顯示廣告
  final List<BannerPhoto>? adsList; // 廣告列表
  final int adsInterval; // 每隔多少個影片顯示一則廣告

  const SliverVodGrid({
    Key? key,
    this.film = 1,
    required this.videos,
    required this.displayNoMoreData,
    required this.isListEmpty,
    required this.displayLoading,
    this.noMoreWidget,
    this.headerExtends,
    this.onScrollEnd,
    this.displayCoverVertical = false,
    this.displayVideoFavoriteTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.customScrollController,
    this.padding,
    this.displayAds = false,
    this.adsList,
    this.adsInterval = 8,
    this.onOverrideRedirectTap,
  }) : super(key: key);

  @override
  SliverVodGridState createState() => SliverVodGridState();
}

class SliverVodGridState extends State<SliverVodGrid> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: kIsWeb ? null : const BouncingScrollPhysics(),
      controller: widget.customScrollController,
      scrollBehavior:
          ScrollConfiguration.of(context).copyWith(scrollbars: false),
      slivers: [
        ...?widget.headerExtends,
        if (widget.isListEmpty) const SliverToBoxAdapter(child: NoDataWidget()),
        _buildVideoGrid(),
        if (widget.displayLoading) const SliverVideoPreviewSkeletonList(),
        if (widget.displayNoMoreData)
          SliverToBoxAdapter(child: widget.noMoreWidget),
      ],
    );
  }

  Widget _buildVideoGrid() {
    List<Widget> rowsAndAds = [];
    for (int i = 0; i < widget.videos.length; i++) {
      if (widget.displayAds && shouldInsertAd(i)) {
        _addAdWidget(rowsAndAds);
      }
      _addVideoRow(rowsAndAds, i);
      i++; // Skip next video as it's already added in the row.
    }
    // Add a final ad if ads are being displayed and list is not empty
    if (widget.displayAds && widget.videos.isNotEmpty) {
      _addAdWidget(rowsAndAds);
    }
    return SliverPadding(
      padding: EdgeInsets.all(widget.padding ?? 8.0),
      sliver: SliverList(delegate: SliverChildListDelegate(rowsAndAds)),
    );
  }

  void _addVideoRow(List<Widget> rowsAndAds, int index) {
    var firstVideo = widget.videos[index];
    Widget firstVideoWidget = VideoPreviewWidget(
      id: firstVideo.id,
      film: widget.film,
      displayCoverVertical: widget.displayCoverVertical ?? false,
      coverVertical: firstVideo.coverVertical!,
      coverHorizontal: firstVideo.coverHorizontal!,
      timeLength: firstVideo.timeLength!,
      tags: firstVideo.tags!,
      title: firstVideo.title,
      videoViewTimes: firstVideo.videoViewTimes!,
      videoFavoriteTimes: firstVideo.videoFavoriteTimes!,
      displayVideoFavoriteTimes: widget.displayVideoFavoriteTimes,
      displayVideoTimes: widget.displayVideoTimes,
      displayViewTimes: widget.displayViewTimes,
      onOverrideRedirectTap: widget.onOverrideRedirectTap,
    );

    // Check if there is a second video to display in the row
    Widget? secondVideoWidget;
    if (index + 1 < widget.videos.length) {
      var secondVideo = widget.videos[index + 1];
      secondVideoWidget = VideoPreviewWidget(
        id: secondVideo.id,
        film: widget.film,
        displayCoverVertical: widget.displayCoverVertical ?? false,
        coverVertical: secondVideo.coverVertical!,
        coverHorizontal: secondVideo.coverHorizontal!,
        timeLength: secondVideo.timeLength!,
        tags: secondVideo.tags!,
        title: secondVideo.title,
        videoViewTimes: secondVideo.videoViewTimes!,
        videoFavoriteTimes: secondVideo.videoFavoriteTimes!,
        displayVideoFavoriteTimes: widget.displayVideoFavoriteTimes,
        displayVideoTimes: widget.displayVideoTimes,
        displayViewTimes: widget.displayViewTimes,
        onOverrideRedirectTap: widget.onOverrideRedirectTap,
      );
    }

    rowsAndAds.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: firstVideoWidget),
            if (secondVideoWidget != null) SizedBox(width: widget.padding ?? 8),
            if (secondVideoWidget != null) Expanded(child: secondVideoWidget),
          ],
        ),
      ),
    );
  }

  void _addAdWidget(List<Widget> rowsAndAds) {
    if (widget.adsList != null && widget.adsList!.isNotEmpty) {
      var ad = widget.adsList![rowsAndAds.length % widget.adsList!.length];
      rowsAndAds.add(AdWidget(ad: ad));
    }
  }

  bool shouldInsertAd(int index) =>
      index > 0 && index % widget.adsInterval == 0;
}

class AdWidget extends StatelessWidget {
  final BannerPhoto ad;
  const AdWidget({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BannerLink(
      id: ad.id,
      url: ad.url ?? '',
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        height: 120,
        child: SidImage(sid: ad.photoSid),
      ),
    );
  }
}
