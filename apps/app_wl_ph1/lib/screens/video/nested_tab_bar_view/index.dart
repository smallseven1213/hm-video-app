import 'package:app_wl_ph1/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/videos/video_by_actor_consumer.dart';
import 'package:shared/modules/videos/video_by_internal_tag_consumer.dart';
import 'package:shared/modules/videos/video_by_tag_consumer.dart';

import '../../../widgets/list_no_more.dart';
import '../../../widgets/tab_bar.dart';
import '../../../widgets/sliver_vod_grid.dart';
import 'app_download_ad.dart';
import 'banner.dart';
import 'video_actions.dart';
import 'video_info.dart';

final logger = Logger();

class NestedTabBarView extends StatefulWidget {
  final Vod videoDetail;
  final String videoUrl;
  const NestedTabBarView({
    Key? key,
    required this.videoDetail,
    required this.videoUrl,
  }) : super(key: key);

  @override
  NestedTabBarViewState createState() => NestedTabBarViewState();
}

class NestedTabBarViewState extends State<NestedTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, length: widget.videoDetail.actors!.isEmpty ? 2 : 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);

    final List<String> tabs = widget.videoDetail.actors!.isEmpty
        ? [I18n.sameType, I18n.sameTag]
        : [I18n.sameActor, I18n.sameType, I18n.sameTag];

    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: VideoInfo(
                  videoPlayerController: obsVideoPlayerController,
                  externalId: widget.videoDetail.externalId ?? '',
                  title: widget.videoDetail.title,
                  tags: widget.videoDetail.tags ?? [],
                  timeLength: widget.videoDetail.timeLength ?? 0,
                  viewTimes: widget.videoDetail.videoViewTimes ?? 0,
                  actor: widget.videoDetail.actors,
                  publisher: widget.videoDetail.publisher,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: VideoActions(
                  videoDetail: Vod(
                    widget.videoDetail.id,
                    widget.videoDetail.title,
                    coverHorizontal: widget.videoDetail.coverHorizontal!,
                    coverVertical: widget.videoDetail.coverVertical!,
                    timeLength: widget.videoDetail.timeLength!,
                    tags: widget.videoDetail.tags!,
                    videoViewTimes: widget.videoDetail.videoViewTimes!,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                child: AppDownloadAd(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                child: VideoScreenBanner(),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarHeaderDelegate(_tabController, tabs),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            if (widget.videoDetail.actors!.isNotEmpty)
              VideoByActorConsumer(
                excludeId: widget.videoDetail.id.toString(),
                actorId: [widget.videoDetail.actors![0]],
                child: (videos) {
                  return SliverVodGrid(
                    key: const Key('video_by_actor'),
                    isListEmpty: videos.isEmpty,
                    videos: videos,
                    displayNoMoreData: false,
                    displayLoading: false,
                    noMoreWidget: ListNoMore(),
                    displayVideoFavoriteTimes: false,
                  );
                },
              ),
            VideoByInternalTagConsumer(
              excludeId: widget.videoDetail.id.toString(),
              internalTagIds: widget.videoDetail.internalTagIds ?? [],
              child: (videos) {
                return SliverVodGrid(
                  key: const Key('video_by_internal_tag'),
                  isListEmpty: videos.isEmpty,
                  videos: videos,
                  displayNoMoreData: false,
                  displayLoading: false,
                  noMoreWidget: ListNoMore(),
                  displayVideoFavoriteTimes: false,
                );
              },
            ),
            VideoByTagConsumer(
              excludeId: widget.videoDetail.id.toString(),
              tags: widget.videoDetail.tags ?? [],
              child: (videos) {
                return SliverVodGrid(
                  key: const Key('video_by_tag'),
                  isListEmpty: videos.isEmpty,
                  videos: videos,
                  displayNoMoreData: false,
                  displayLoading: false,
                  noMoreWidget: ListNoMore(),
                  displayVideoFavoriteTimes: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> tabs;

  TabBarHeaderDelegate(this.tabController, this.tabs);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GSTabBar(
      controller: tabController,
      tabs: tabs,
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant TabBarHeaderDelegate oldDelegate) {
    return false;
  }
}
