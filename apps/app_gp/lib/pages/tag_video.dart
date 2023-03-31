import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/video_preview.dart';

class TagVideoPage extends StatelessWidget {
  TagVideoPage({Key? key}) : super(key: key);

  final UserCollectionController userCollectionController =
      Get.find<UserCollectionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '我的收藏',
      ),
      body: Obx(() {
        var videos = userCollectionController.videos;
        return AlignedGridView.count(
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 2,
          itemCount: userCollectionController.videos.length,
          itemBuilder: (BuildContext context, int index) =>
              Obx(() => VideoPreviewWidget(
                    id: videos[index].detail?.id ?? videos[index].id,
                    title: videos[index].title,
                    tags: videos[index].tags,
                    timeLength: videos[index].timeLength,
                    coverHorizontal: videos[index].coverHorizontal,
                    coverVertical: videos[index].coverVertical,
                    videoViewTimes: videos[index].videoViewTimes,
                    detail: videos[index].detail,
                  )),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 10.0,
        );
      }),
    );
  }
}
