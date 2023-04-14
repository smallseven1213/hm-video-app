import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_video_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/models/vod.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/video_preview.dart';

class TagVideoPage extends StatelessWidget {
  final int id;
  final String title;
  const TagVideoPage({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TagVideoController tagVideoController =
        Get.put(TagVideoController(id), tag: 'tag_video-$id');

    final ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        tagVideoController.fetchMoreVideos();
      }
    });
    return Scaffold(
      appBar: CustomAppBar(
        title: '#$title',
      ),
      body: Obx(() => CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              ...tagVideoController.blocks
                  .map((e) => SliverBlockWidget(vods: e.vods))
                  .toList(),
            ],
          )),
    );
  }
}

class SliverBlockWidget extends StatelessWidget {
  final List<Vod> vods;
  const SliverBlockWidget({
    Key? key,
    required this.vods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: const EdgeInsets.all(8.0),
        sliver: SliverAlignedGrid.count(
          crossAxisCount: 2,
          itemCount: vods.length,
          itemBuilder: (BuildContext context, int index) {
            var video = vods[index];
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
        ));
  }
}
