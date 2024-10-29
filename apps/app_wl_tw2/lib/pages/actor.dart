import 'package:app_wl_tw2/config/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/actor/actor_consumer.dart';
import 'package:shared/modules/actor/actor_provider.dart';
import 'package:shared/modules/videos/actor_hotest_videos_consumer.dart';
import 'package:shared/modules/videos/actor_latest_videos_consumer.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildVideosWidget(String key, vodList, displayLoading,
      displayNoMoreData, isListEmpty, onLoadMore, index) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (_tabController.index == index &&
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
        displayVideoFavoriteTimes: false,
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
                    child: Container(
                      color: AppColors.colors[ColorKeys.primary],
                      height: MediaQuery.paddingOf(context).top,
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
                            onLoadMore,
                            0),
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
                            onLoadMore,
                            1),
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
    return TabBarWidget(
      controller: tabController,
      tabs: [I18n.latest, I18n.hot],
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
