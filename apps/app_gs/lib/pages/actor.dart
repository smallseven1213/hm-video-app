import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/actor_controller.dart';
import 'package:shared/controllers/actor_hottest_vod_controller.dart';
import 'package:shared/controllers/actor_latest_vod_controller.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/actor/card.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';
import '../widgets/tab_bar.dart';

final logger = Logger();

class ActorPage extends StatefulWidget {
  final int id;
  const ActorPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ActorPageState createState() => ActorPageState();
}

class ActorPageState extends State<ActorPage>
    with SingleTickerProviderStateMixin {
  late ActorLatestVodController actorLatestVodController;
  late ActorHottestVodController actorNewestVodController;
  late ActorController actorController;
  late TabController _tabController;
  late ScrollController _parentScrollController;
  late ScrollController actorLatestVodScrollController;
  late ScrollController actorNewestVodScrollController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ActorController(actorId: widget.id),
        tag: 'actor-${widget.id}');
    actorController = Get.find(tag: 'actor-${widget.id}');
    _tabController = TabController(vsync: this, length: 2);
    _parentScrollController = ScrollController();

    actorLatestVodController = ActorLatestVodController(actorId: widget.id);
    actorNewestVodController = ActorHottestVodController(actorId: widget.id);
    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging) {
    //     _parentScrollController.jumpTo(0.0);
    //     if (_tabController.index == 0) {
    //       if (actorLatestVodScrollController.hasClients) {
    //         actorLatestVodScrollController.jumpTo(0.0);
    //       }
    //     } else {
    //       if (actorNewestVodScrollController.hasClients) {
    //         actorNewestVodScrollController.jumpTo(0.0);
    //       }
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _parentScrollController.dispose();
    actorLatestVodController.dispose();
    actorNewestVodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      var actor = actorController.actor.value;
      return Stack(
        children: [
          NestedScrollView(
              // controller: _parentScrollController,
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // 返回一个 Sliver 数组给外部可滚动组件。
                return <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: ActorCard(actor: actor, context: context),
                    pinned: true,
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: TabBarHeaderDelegate(_tabController),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (_tabController.index == 0 &&
                          scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        actorLatestVodController.loadMoreData();
                      }
                      return false;
                    },
                    child: Obx(() => SliverVodGrid(
                          key: const PageStorageKey<String>('actor_latest_vod'),
                          // customScrollController:
                          //     actorLatestVodScrollController,
                          videos: actorLatestVodController.vodList,
                          displayLoading:
                              actorLatestVodController.displayLoading.value,
                          displayNoMoreData:
                              actorLatestVodController.displayNoMoreData.value,
                          isListEmpty:
                              actorLatestVodController.isListEmpty.value,
                          noMoreWidget: ListNoMore(),
                          displayVideoCollectTimes: false,
                        )),
                  ),
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (_tabController.index == 1 &&
                          scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        actorNewestVodController.loadMoreData();
                      }
                      return false;
                    },
                    child: Obx(() => SliverVodGrid(
                          key: const PageStorageKey<String>('actor_newest_vod'),
                          // customScrollController:
                          //     actorNewestVodScrollController,
                          videos: actorNewestVodController.vodList,
                          displayLoading:
                              actorNewestVodController.displayLoading.value,
                          displayNoMoreData:
                              actorNewestVodController.displayNoMoreData.value,
                          isListEmpty:
                              actorNewestVodController.isListEmpty.value,
                          noMoreWidget: ListNoMore(),
                          displayVideoCollectTimes: false,
                        )),
                  ),
                ],
              )),
          const FloatPageBackButton()
        ],
      );
    }));
  }
}

class TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  TabBarHeaderDelegate(this.tabController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GSTabBar(
      controller: tabController,
      tabs: const ['最新', '最熱'],
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant TabBarHeaderDelegate oldDelegate) {
    return false;
  }
}
