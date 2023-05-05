import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  _ActorPageState createState() => _ActorPageState();
}

class _ActorPageState extends State<ActorPage>
    with SingleTickerProviderStateMixin {
  late ActorLatestVodController actorLatestVodController;
  late ActorHottestVodController actorNewestVodController;
  late ActorController actorController;
  late TabController _tabController;
  final ScrollController _parentScrollController = ScrollController();

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    actorLatestVodController = ActorLatestVodController(
        actorId: widget.id, scrollController: _parentScrollController);
    actorNewestVodController = ActorHottestVodController(
        actorId: widget.id, scrollController: _parentScrollController);
    actorController = ActorController(actorId: widget.id);
    _tabController = TabController(vsync: this, length: 2);

    actorLatestVodController.scrollController.addListener(() {
      _parentScrollController
          .jumpTo(actorLatestVodController.scrollController.offset);
    });
    actorNewestVodController.scrollController.addListener(() {
      _parentScrollController
          .jumpTo(actorNewestVodController.scrollController.offset);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _parentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      var actor = actorController.actor.value;
      return Stack(
        children: [
          NestedScrollView(
              controller: _parentScrollController,
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
                  SliverVodGrid(
                    key: const Key('actor_latest_vod'),
                    videos: actorLatestVodController.vodList,
                    hasMoreData: actorLatestVodController.hasMoreData.value,
                    noMoreWidget: const ListNoMore(),
                    scrollController: actorLatestVodController.scrollController,
                  ),
                  SliverVodGrid(
                    key: const Key('actor_newest_vod'),
                    videos: actorNewestVodController.vodList,
                    hasMoreData: actorNewestVodController.hasMoreData.value,
                    noMoreWidget: const ListNoMore(),
                    scrollController: actorNewestVodController.scrollController,
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
