import 'dart:ui';

import 'package:app_tt/screens/actor/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/modules/actor/actor_consumer.dart';
import 'package:shared/modules/actor/actor_provider.dart';
import 'package:shared/modules/videos/actor_hotest_videos_consumer.dart';
import 'package:shared/modules/user/user_favorites_actor_consumer.dart';
import 'package:shared/modules/videos/actor_latest_videos_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/actor/header.dart';
import '../widgets/actor_avatar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';
import '../widgets/statistic_item.dart';

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
        displayVideoCollectTimes: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActorProvider(
      id: widget.id,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/user-bg.webp'),
            ),
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: ActorHeader(context: context, id: widget.id),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: ActorConsumer(
                        id: widget.id,
                        child: (Actor actor) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StatisticsItem(
                                  count: actor.actorCollectTimes ?? 0,
                                  label: '讚數',
                                ),
                                const SizedBox(width: 20),
                                StatisticsItem(
                                  count: actor.containVideos ?? 0,
                                  label: '影片數',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              actor.description!,
                              softWrap: true,
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            FollowButton(id: widget.id, actor: actor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: TabBarHeaderDelegate(_tabController),
                  )
                ];
              },
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Container(
                    color: Colors.white,
                    child: ActorLatestVideosConsumer(
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
                  ),
                  Container(
                    color: Colors.white,
                    child: ActorHottestVideosConsumer(
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
                  ),
                ],
              ),
            ),
            const FloatPageBackButton()
          ],
        ),
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
    return Container(
      height: 60,
      color: Colors.white,
      child: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: const Color(0xFF73747b),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Color(0xFF161823), // 这里是你想要的颜色
              width: 2.0, // 这是下划线的宽度，可以根据需要进行调整
            ),
          ),
          tabs: const [Tab(text: '最新'), Tab(text: '最熱')]),
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
