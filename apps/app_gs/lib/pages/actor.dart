import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_controller.dart';
import 'package:shared/controllers/actor_vod_controller.dart';

import '../screens/actor/card.dart';
import '../screens/actor/video.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/video_preview.dart';

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
  late ActorVodController actorVodController;
  late ActorController actorController;
  late TabController _tabController;
  late ScrollController _parentScrollController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    actorVodController = ActorVodController(actorId: widget.id);
    actorController = ActorController(actorId: widget.id);
    _tabController = TabController(vsync: this, length: 2);
    _parentScrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _parentScrollController.dispose();
    super.dispose();
  }

  // void _handleScroll(ScrollNotification notification) {
  //   if (notification is ScrollUpdateNotification) {
  //     final currentOffset = _parentScrollController.offset;
  //     final delta = notification.scrollDelta!;
  //     _parentScrollController.jumpTo(currentOffset + delta);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => CustomScrollView(
            // controller: actorVodController.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                delegate: ActorCard(actor: actorController.actor.value),
                pinned: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverAlignedGrid.count(
                  crossAxisCount: 2,
                  itemCount: actorVodController.vodList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var video = actorVodController.vodList[index];
                    return VideoPreviewWidget(
                        id: video.id,
                        coverVertical: video.coverVertical!,
                        coverHorizontal: video.coverHorizontal!,
                        timeLength: video.timeLength!,
                        tags: video.tags!,
                        title: video.title,
                        videoViewTimes: video.videoViewTimes!);
                  },
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 10.0,
                ),
              ),
              if (actorVodController.hasMoreData)
                const SliverVideoPreviewSkeletonList(),
              if (!actorVodController.hasMoreData)
                const SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          )),
    );
  }
}
