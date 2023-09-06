import 'package:app_gs/screens/video/nested_tab_bar_view/video_list.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/videos/video_by_actor_consumer.dart';
import 'package:shared/modules/videos/video_by_internal_tag_consumer.dart';
import 'package:shared/modules/videos/video_by_tag_consumer.dart';

import 'nested_tab_bar_view/enums.dart';

class RelatedVideos extends StatelessWidget {
  final TabController tabController;
  final Vod videoDetail;

  const RelatedVideos({
    super.key,
    required this.tabController,
    required this.videoDetail,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        videoDetail.actors!.isEmpty
            ? const SizedBox()
            : VideoByActorConsumer(
                excludeId: videoDetail.id.toString(),
                actorId: [videoDetail.actors![0]],
                child: (videos) {
                  return VideoList(
                    videos: videos,
                    tabController: tabController,
                    category: VideoFilterType.actor,
                  );
                },
              ),
        VideoByInternalTagConsumer(
          excludeId: videoDetail.id.toString(),
          internalTagIds: videoDetail.internalTagIds ?? [],
          child: (videos) {
            return VideoList(
              videos: videos,
              tabController: tabController,
              category: VideoFilterType.category,
            );
          },
        ),
        VideoByTagConsumer(
          excludeId: videoDetail.id.toString(),
          tags: videoDetail.tags ?? [],
          child: (videos) {
            return VideoList(
              videos: videos,
              tabController: tabController,
              category: VideoFilterType.tag,
            );
          },
        ),
      ],
    );
  }
}
