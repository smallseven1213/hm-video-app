import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';

class FavoritesVideoScreen extends StatelessWidget {
  FavoritesVideoScreen({Key? key}) : super(key: key);

  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = userFavoritesVideoController.videos;
      return AlignedGridView.count(
        crossAxisCount: 2,
        itemCount: videos.length,
        itemBuilder: (BuildContext context, int index) {
          var video = videos[index];
          return VideoPreviewWidget(
              id: video.id,
              coverVertical: video.coverVertical,
              coverHorizontal: video.coverHorizontal,
              timeLength: video.timeLength,
              tags: video.tags,
              title: video.title,
              videoViewTimes: video.videoViewTimes);
        },
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 10.0,
      );
    });
  }
}
