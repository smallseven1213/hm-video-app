import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/block_videos_by_category_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';

import '../../../widgets/list_no_more.dart';
import '../../../widgets/sliver_vod_grid.dart';
import '../../../widgets/tab_bar.dart';
import 'app_download_ad.dart';
import 'banner.dart';
import 'video_actions.dart';
import 'video_info.dart';

final logger = Logger();

class NestedTabBarView extends StatefulWidget {
  final Vod videoDetail;
  final Vod videoBase;
  final String videoUrl;
  const NestedTabBarView({
    Key? key,
    required this.videoDetail,
    required this.videoBase,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _NestedTabBarViewState createState() => _NestedTabBarViewState();
}

class _NestedTabBarViewState extends State<NestedTabBarView>
    with SingleTickerProviderStateMixin {
  late BlockVideosByCategoryController blockVideosController;
  late TabController _tabController;
  late ScrollController _parentScrollController;

  int tabIndex = 0;

  String getIdList(List inputList) {
    if (inputList.isEmpty) return '';
    return inputList.take(3).map((e) => e.id.toString()).join(',');
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, length: widget.videoDetail.actors!.isEmpty ? 2 : 3);
    _parentScrollController = ScrollController();
    blockVideosController = Get.put(
      BlockVideosByCategoryController(
        tagId: getIdList(widget.videoDetail.tags!),
        actorId: widget.videoDetail.actors!.isEmpty
            ? null
            : widget.videoDetail.actors![0].id.toString(),
        excludeId: widget.videoDetail.id.toString(),
        internalTagId: widget.videoDetail.internalTagIds!.join(',').toString(),
      ),
      tag: DateTime.now().toString(),
    );
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
        ? ['同類型', '同標籤']
        : ['同演員', '同類型', '同標籤'];

    return Scaffold(
      body: NestedScrollView(
        controller: _parentScrollController,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                child: VideoInfo(
                  playVideo: () {
                    obsVideoPlayerController.play();
                  },
                  pauseVideo: () {
                    obsVideoPlayerController.pause();
                  },
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
                  videoDetail: Vod.fromJson({
                    ...widget.videoDetail.toJson(),
                    ...widget.videoBase.toJson(),
                  }),
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
                SliverVodGrid(
                    key: const Key('video_by_actor'),
                    videos: blockVideosController.videoByActor,
                    hasMoreData: false,
                    noMoreWidget: const ListNoMore(),
                    usePrimaryParentScrollController: true,
                    onScrollEnd: () {}),
              SliverVodGrid(
                  key: const Key('video_by_internal_tag'),
                  videos: blockVideosController.videoByInternalTag,
                  hasMoreData: false,
                  noMoreWidget: const ListNoMore(),
                  usePrimaryParentScrollController: true,
                  onScrollEnd: () {}),
              SliverVodGrid(
                  key: const Key('video_by_tag'),
                  videos: blockVideosController.videoByTag,
                  hasMoreData: false,
                  noMoreWidget: const ListNoMore(),
                  usePrimaryParentScrollController: true,
                  onScrollEnd: () {}),
            ]),
        //   )
        // ],
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
