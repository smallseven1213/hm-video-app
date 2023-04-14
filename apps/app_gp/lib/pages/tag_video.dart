import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_vod_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
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
    final TagVodController tagVideoController = TagVodController(tagId: id);

    return Scaffold(
      appBar: CustomAppBar(
        title: '#$title',
      ),
      body: Obx(() => CustomScrollView(
            controller: tagVideoController.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverAlignedGrid.count(
                  crossAxisCount: 2,
                  itemCount: tagVideoController.vodList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var video = tagVideoController.vodList[index];
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
              if (!tagVideoController.hasMoreData)
                const SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          )),
    );
  }
}
