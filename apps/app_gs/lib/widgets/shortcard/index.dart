import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import 'package:shared/widgets/video_player/player.dart';
import 'short_card_info.dart';

final logger = Logger();

class ShortCard extends StatefulWidget {
  final bool isActive;
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;

  const ShortCard(
      {Key? key,
      required this.index,
      required this.id,
      required this.title,
      required this.isActive,
      this.supportedPlayRecord = true})
      : super(key: key);

  @override
  ShortCardState createState() => ShortCardState();
}

class ShortCardState extends State<ShortCard> {
  bool obpControllerisReady = false;
  ShortVideoDetailController? videoDetailController;

  @override
  void initState() {
    super.initState();

    videoDetailController = Get.find<ShortVideoDetailController>(
        tag: genaratorShortVideoDetailTag(widget.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isLoading = videoDetailController!.isLoading.value;
      var video = videoDetailController!.video.value;
      var videoDetail = videoDetailController!.videoDetail.value;
      var videoUrl = videoDetailController!.videoUrl.value;
      if (!isLoading &&
          videoUrl.isNotEmpty &&
          video != null &&
          videoDetail != null) {
        return Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: VideoPlayerWidget(
                isActive: widget.isActive,
                video: video,
                videoUrl: videoUrl,
              ),
            ),
            ShortCardInfo(
              data: videoDetail,
              title: widget.title,
              videoUrl: videoUrl,
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
