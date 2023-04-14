import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_controller.dart';
import 'package:shared/controllers/actor_vod_controller.dart';
import 'package:shared/controllers/tag_video_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/models/vod.dart';

import '../screens/actor/card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/video_preview.dart';

class ActorPage extends StatelessWidget {
  final int id;
  const ActorPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actorVodController = ActorVodController(actorId: id);
    final actorController = ActorController(actorId: id);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => CustomAppBar(
            title: actorController.actor.value.name,
          ),
        ),
      ),
      body: Obx(() => CustomScrollView(
            controller: actorVodController.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ActorCard(
                  id: actorController.actor.value.id,
                  name: actorController.actor.value.name,
                  photoSid: actorController.actor.value.photoSid,
                  description: actorController.actor.value.description!,
                  actorCollectTimes:
                      actorController.actor.value.actorCollectTimes.toString(),
                  coverVertical: actorController.actor.value.coverVertical,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Add this line
                    children: [
                      const Icon(
                        Icons.videocam_outlined,
                        color: Color(0xFF21AFFF),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        actorVodController.totalCount.value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
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
              if (!actorVodController.hasMoreData)
                const SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          )),
    );
  }
}
