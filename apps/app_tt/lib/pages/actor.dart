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

import '../screens/actor/statistics_row.dart';
import '../widgets/actor_avatar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';

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
                    delegate: UserHeader(context: context, id: widget.id),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ActorConsumer(
                            id: widget.id,
                            child: (Actor actor) => StatisticsRow(
                              likes: actor.collectTimes.toString(),
                              videos: actor.containVideos.toString(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ActorConsumer(
                            id: widget.id,
                            child: (Actor actor) => Text(
                              actor.description!,
                              softWrap: true,
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ActorConsumer(
                            id: widget.id,
                            child: (Actor actor) =>
                                FollowButton(id: widget.id, actor: actor),
                          ),
                        ],
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

class UserHeader extends SliverPersistentHeaderDelegate {
  final BuildContext context;
  final int id;

  UserHeader({
    required this.context,
    required this.id,
  });

  @override
  double get minExtent {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return kToolbarHeight + statusBarHeight;
  }

  @override
  double get maxExtent =>
      164 + kToolbarHeight + MediaQuery.of(context).padding.top;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final shouldShowAppBar = shrinkOffset >= 164;
    final double percentage = shrinkOffset / maxExtent;

    final double imageSize = lerpDouble(80, kToolbarHeight - 20, percentage)!;
    final double fontSize = lerpDouble(21, 15, percentage)!;
    final double fontSize2 = lerpDouble(14, 10, percentage)!;

    return shouldShowAppBar
        ? ActorConsumer(
            id: id,
            child: (Actor info) => AppBar(
              // iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  MyRouteDelegate.of(context).pop();
                },
              ),
              elevation: 0,
              title: UserFavoritesActorConsumer(
                  id: id,
                  info: info,
                  child: (isLiked, handleLike) => InkWell(
                        onTap: handleLike,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: isLiked
                                ? const Color(0xfff1f1f2)
                                : const Color(0xfffff3f5),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ActorAvatar(
                                  width: 21,
                                  height: 21,
                                  photoSid: info.photoSid),
                              const SizedBox(width: 8),
                              Text(
                                isLiked ? '已關注' : '+ 關注',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isLiked
                                      ? const Color(0xff161823)
                                      : const Color(0xfffe2c55),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
              centerTitle: false, // This will center the title
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search_rounded,
                      color: Colors.black, size: 24),
                  onPressed: () {
                    MyRouteDelegate.of(context).push(AppRoutes.search, args: {
                      'inputDefaultValue': info.name,
                      'autoSearch': true
                    });
                  },
                ),
              ],
            ),
          )
        : SizedBox(
            height: maxExtent - shrinkOffset,
            child: ActorConsumer(
              id: id,
              child: (Actor actor) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ActorAvatar(
                        photoSid: actor.photoSid,
                        width: imageSize,
                        height: imageSize,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            actor.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '用戶ID: ${actor.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          );
  }

  @override
  bool shouldRebuild(covariant UserHeader oldDelegate) {
    return false;
  }
}
