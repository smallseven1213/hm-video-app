import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_controller.dart';
import 'package:shared/controllers/actor_hottest_vod_controller.dart';
import 'package:shared/controllers/actor_latest_vod_controller.dart';

import '../screens/actor/card.dart';
import '../screens/actor/video.dart';

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
      return NestedScrollView(
          controller: _parentScrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // 返回一个 Sliver 数组给外部可滚动组件。
            return <Widget>[
              SliverPersistentHeader(
                delegate: ActorCard(actor: actor),
                pinned: true,
              ), //构建一个 sliverList
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              ActorVideoScreen(
                key: const Key('actor_latest_vod'),
                id: widget.id,
                type: 'vod',
                vodController: actorLatestVodController,
                scrollController: _parentScrollController,
              ),
              ActorVideoScreen(
                key: const Key('actor_newest_vod'),
                id: widget.id,
                type: 'series',
                vodController: actorNewestVodController,
                scrollController: _parentScrollController,
              ),
            ],
          ));
    }));
  }
}
