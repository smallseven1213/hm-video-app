import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/widgets/video_player/player.dart';

import '../../pages/video.dart';
import '../../screens/video/video_player_area/index.dart';
import 'short_card_info.dart';

final logger = Logger();

class ShortCard extends StatelessWidget {
  final int index;
  final int id;
  final String title;
  final bool isActive;

  const ShortCard({
    Key? key,
    required this.index,
    required this.id,
    required this.title,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShortVideoDetailController? videoDetailController =
        Get.put(ShortVideoDetailController(id), tag: id.toString());

    return Obx(() {
      var video = videoDetailController!.video.value;
      var videoDetail = videoDetailController.videoDetail.value;

      if (video != null && videoDetailController.videoUrl.value.isNotEmpty) {
        String videoUrl = videoDetailController.videoUrl.value;
        Get.put(ObservableVideoPlayerController(videoUrl), tag: videoUrl);

        return Expanded(
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: VideoPlayerWidget(
                  isActive: isActive,
                  video: video,
                  videoUrl: videoUrl,
                ),
              ),
              if (videoDetail != null)
                ShortCardInfo(
                    index: index,
                    data: videoDetail,
                    title: title,
                    videoUrl: videoUrl)
            ],
          ),
        );
      } else {
        // video is null or videoUrl is null:
        // return CircularProgressIndicator();
        return const SizedBox.shrink();
      }
    });
  }
}
