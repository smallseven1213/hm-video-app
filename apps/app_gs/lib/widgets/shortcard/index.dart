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
  ShortVideoDetailController? videoDetailController;
  ObservableVideoPlayerController? videoPlayerController;

  late StreamSubscription<String> videoUrlSubscription;

  @override
  void initState() {
    super.initState();
    logger.i('RENDER OBX: ShortCard initState');
    videoDetailController =
        Get.find<ShortVideoDetailController>(tag: widget.id.toString());

    var videoUrl = videoDetailController!.videoUrl.value;
    if (videoUrl.isNotEmpty) {
      _putController();
    }
    videoUrlSubscription = videoDetailController!.videoUrl.listen((videoUrl) {
      if (videoUrl.isNotEmpty) {
        var video = videoDetailController!.video.value;
        if (widget.supportedPlayRecord == true) {
          var playRecord = VideoDatabaseField(
            id: video!.id,
            coverHorizontal: video.coverHorizontal!,
            coverVertical: video.coverVertical!,
            timeLength: video.timeLength!,
            videoCollectTimes:
                videoDetailController!.videoDetail.value!.collects,
            tags: [],
            title: video.title,
            // detail: detail!,
          );
          logger.i('PLAYRECORD TRACE: ShortCard initState addPlayRecord');
          Get.find<PlayRecordController>(tag: 'short')
              .addPlayRecord(playRecord);
        }
        _putController();
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

    setState(() {});
  }

  @override
  void dispose() {
    videoUrlSubscription.cancel(); // 在dispose方法中取消订阅
    videoDetailController?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Obx(() {
        if (!Get.isRegistered<ShortVideoDetailController>(
            tag: widget.id.toString())) {
          return const SizedBox.shrink();
        }
        var video = videoDetailController!.video.value;
        var videoDetail = videoDetailController!.videoDetail.value;
        if (video != null &&
            videoDetail != null &&
            videoDetailController!.videoUrl.value.isNotEmpty) {
          return Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: VideoPlayerWidget(
                  video: video,
                  videoUrl: videoDetailController!.videoUrl.value,
                ),
              ),
              ShortCardInfo(
                index: widget.index,
                data: videoDetail,
                title: widget.title,
                videoUrl: videoDetailController!.videoUrl.value,
              )
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      });
    } catch (e, s) {
      return const SizedBox.shrink();
    }
  }
}
