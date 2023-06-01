import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/video_database_field.dart';
import 'package:shared/widgets/video_player/player.dart';

import '../../pages/video.dart';
import '../../screens/video/video_player_area/index.dart';
import 'short_card_info.dart';

final logger = Logger();

class ShortCard extends StatefulWidget {
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;

  const ShortCard(
      {Key? key,
      required this.index,
      required this.id,
      required this.title,
      this.supportedPlayRecord = true})
      : super(key: key);

  @override
  _ShortCardState createState() => _ShortCardState();
}

class _ShortCardState extends State<ShortCard> {
  bool obpControllerisReady = false;
  ShortVideoDetailController? videoDetailController;
  ObservableVideoPlayerController? videoPlayerController;

  late StreamSubscription<bool> videoUrlSubscription;

  @override
  void initState() {
    super.initState();

    videoDetailController =
        Get.find<ShortVideoDetailController>(tag: widget.id.toString());

    videoUrlSubscription = videoDetailController!.isLoading.listen((isLoading) {
      if (isLoading == false) {
        _putController();
        var video = videoDetailController!.video.value;
        if (widget.supportedPlayRecord == true && video != null) {
          var playRecord = VideoDatabaseField(
            id: video.id,
            coverHorizontal: video.coverHorizontal!,
            coverVertical: video.coverVertical!,
            timeLength: video.timeLength!,
            videoCollectTimes:
                videoDetailController!.videoDetail.value!.videoCollectTimes,
            tags: [],
            title: video.title,
          );
          Get.find<PlayRecordController>(tag: 'short')
              .addPlayRecord(playRecord);
        }
      }
    });
  }

  void _putController() async {
    var videoUrl = videoDetailController!.videoUrl.value;
    videoPlayerController?.dispose();
    await Get.putAsync<ObservableVideoPlayerController>(() async {
      videoPlayerController = ObservableVideoPlayerController(videoUrl);
      logger.i('RENDER OBX: ShortCard didChangeDependencies retry');
      return videoPlayerController!;
    }, tag: videoUrl);
    logger.i('OBX CHECK: ShortCard _putController');

    setState(() {
      obpControllerisReady = true;
    });
  }

  @override
  void dispose() {
    videoUrlSubscription.cancel();
    // videoDetailController?.dispose();
    // videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isLoading = videoDetailController?.isLoading.value;
      var video = videoDetailController?.video.value;
      var videoDetail = videoDetailController?.videoDetail.value;
      var videoUrl = videoDetailController?.videoUrl.value;
      if (isLoading == false &&
          videoUrl!.isNotEmpty &&
          video != null &&
          videoDetail != null) {
        return Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: VideoPlayerWidget(
                video: video,
                videoUrl: videoUrl,
              ),
            ),
            ShortCardInfo(
              index: widget.index,
              data: videoDetail,
              title: widget.title,
              videoUrl: videoUrl,
            )
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
