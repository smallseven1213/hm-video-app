import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/widgets/video_player/player.dart';

import '../../pages/video.dart';
import '../../screens/video/video_player_area/index.dart';
import 'short_card_info.dart';

class ShortCard extends StatelessWidget {
  final int index;
  final int id;
  final String title;

  const ShortCard({
    Key? key,
    required this.index,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShortVideoDetailController? videoDetailController =
        Get.put(ShortVideoDetailController(id), tag: id.toString());

    print('@@@@widget.id: ${id}');

    return Obx(() {
      var video = videoDetailController!.video.value;
      var videoDetail = videoDetailController.videoDetail.value;

      print('@@@@video: ${video}');

      return Expanded(
          child: Stack(
        children: [
          if (video != null) ...[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: VideoPlayerWidget(
                video: video,
                videoUrl: videoDetailController.videoUrl.value,
              ),
            ),
            // Center(
            //   child: Text(
            //     '視頻編號：${video.id}',
            //     style: const TextStyle(
            //       fontSize: 24,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
          if (videoDetail != null)
            ShortCardInfo(index: index, data: videoDetail, title: title)
        ],
      ));
    });
  }
}
