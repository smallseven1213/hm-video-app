import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_detail_controller.dart';

import '../../pages/video.dart';
import 'short_card_info.dart';

class ShortCard extends StatelessWidget {
  final int index;
  final int id;

  const ShortCard({
    Key? key,
    required this.index,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VideoDetailController? videoDetailController =
        Get.put(VideoDetailController(id), tag: id.toString());

    print('@@@@widget.id: ${id}');

    return Obx(() {
      var video = videoDetailController!.video.value;
      var videoDetail = videoDetailController.videoDetail.value;

      return Expanded(
          child: Stack(
        children: [
          if (video != null)
            Center(
              child: Text(
                '視頻編號：${video.id}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          if (videoDetail != null)
            ShortCardInfo(index: index, data: videoDetail)
        ],
      ));
    });
  }
}
