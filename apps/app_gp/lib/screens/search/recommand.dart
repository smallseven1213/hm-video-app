import 'package:app_gp/screens/search/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_popular_controller.dart';
import 'package:shared/controllers/video_popular_controller.dart';

import '../../widgets/header.dart';
import '../../widgets/video_preview.dart';

class RecommandScreen extends StatelessWidget {
  final TagPopularController tagPopularController = Get.find();
  final VideoPopularController videoPopularController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverToBoxAdapter(
          child: Header(
            text: '搜索推荐',
          ),
        ),
        Obx(() => SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8, // 標籤之間的水平間距
                    runSpacing: 8, // 標籤之間的垂直間距
                    children: tagPopularController.data
                        .map((tag) => TagItem(tag: tag.name))
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              ]),
            )),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        const SliverToBoxAdapter(
          child: Header(
            text: '热门推荐',
          ),
        ),
        Obx(() => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              sliver: SliverAlignedGrid.count(
                crossAxisCount: 2,
                itemCount: videoPopularController.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var video = videoPopularController.data[index];
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
            )),
      ],
    );
  }
}
