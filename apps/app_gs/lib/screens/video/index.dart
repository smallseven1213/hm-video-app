// VideoScreen stateless
import 'package:app_gs/screens/video/video_player_area/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_detail_controller.dart';

import 'nested_tab_bar_view/index.dart';
import '../../widgets/custom_app_bar.dart';

final logger = Logger();

class VideoScreen extends StatelessWidget {
  final int id;
  final String? name;

  const VideoScreen({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideoDetailController videoDetailController =
        Get.put(VideoDetailController(id), tag: id.toString());

    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          var video = videoDetailController.video.value;
          var videoDetail = videoDetailController.videoDetail.value;
          return Column(
            children: [
              video != null
                  ? VideoPlayerArea(
                      id: id,
                      name: name,
                      videoUrl: videoDetailController.videoUrl.value,
                      video: video,
                    )
                  : CustomAppBar(
                      title: name ?? '',
                      backgroundColor: Colors.transparent,
                    ),
              Expanded(
                child: video != null && videoDetail != null
                    ? NestedTabBarView(
                        videoBase: video,
                        videoDetail: videoDetail,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              )
            ],
          );
        }),
      ),
    );
  }
}
