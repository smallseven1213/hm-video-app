import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_vod_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_video_preview_skelton_list.dart';
import '../../widgets/video_preview.dart';

class ActorVideoScreen extends StatelessWidget {
  final int id;
  final ScrollController scrollController;
  final Function(ScrollNotification) onScroll;
  ActorVideoScreen(
      {Key? key,
      required this.type,
      required this.id,
      required this.onScroll,
      required this.scrollController})
      : super(key: key);

  final String type;

  Timer? _scrollNotificationTimer;

  void _handleScroll(ScrollNotification notification) {
    if (_scrollNotificationTimer != null &&
        _scrollNotificationTimer!.isActive) {
      return;
    }
    _scrollNotificationTimer = Timer(Duration(milliseconds: 200), () {
      onScroll(notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ActorVodController actorVodController =
        ActorVodController(actorId: id);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        onScroll(notification);
        return false;
      },
      child: Obx(() => CustomScrollView(
            controller: scrollController,
            slivers: [
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
