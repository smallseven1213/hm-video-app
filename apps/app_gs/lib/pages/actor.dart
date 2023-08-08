import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/actor/actor_consumer.dart';
import 'package:shared/modules/actor/actor_provider.dart';
import 'package:shared/modules/videos/actor_hotest_videos_consumer.dart';
import 'package:shared/modules/videos/actor_latest_videos_consumer.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/actor/card.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';
import '../widgets/tab_bar.dart';

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
  late TabController _tabController;
  late ScrollController _parentScrollController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _parentScrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _parentScrollController.dispose();
    super.dispose();
  }

  Widget buildVideosWidget(String key, vodList, displayLoading,
      displayNoMoreData, isListEmpty, onLoadMore) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (_tabController.index == 0 &&
            scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: SliverVodGrid(
        key: PageStorageKey<String>(key),
        videos: vodList,
        displayLoading: displayLoading,
        displayNoMoreData: displayNoMoreData,
        isListEmpty: isListEmpty,
        noMoreWidget: ListNoMore(),
        displayVideoCollectTimes: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActorProvider(
      id: widget.id,
      child: Stack(
        children: [
          NestedScrollView(
              physics: kIsWeb ? null : const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  ),
                  ActorConsumer(
                    id: widget.id,
                    child: (actor) => SliverPersistentHeader(
                      delegate: ActorCard(actor: actor, context: context),
                      pinned: true,
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: TabBarHeaderDelegate(_tabController),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                physics: kIsWeb ? null : const BouncingScrollPhysics(),
                children: [
                  ActorLatestVideosConsumer(
                    id: widget.id,
                    child: (vodList, displayLoading, displayNoMoreData,
                            isListEmpty, onLoadMore) =>
                        buildVideosWidget(
                            'actor_latest_vod',
                            vodList,
                            displayLoading,
                            displayNoMoreData,
                            isListEmpty,
                            onLoadMore),
                  ),
                  ActorHottestVideosConsumer(
                    id: widget.id,
                    child: (vodList, displayLoading, displayNoMoreData,
                            isListEmpty, onLoadMore) =>
                        buildVideosWidget(
                            'actor_hottest_vod',
                            vodList,
                            displayLoading,
                            displayNoMoreData,
                            isListEmpty,
                            onLoadMore),
                  ),
                ],
              )),
          const FloatPageBackButton()
        ],
      ),
    );
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
