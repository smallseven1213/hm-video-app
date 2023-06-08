import 'package:app_gs/screens/video/video_player_area/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/utils/controller_tag_genarator.dart';

import 'nested_tab_bar_view/index.dart';
import '../../widgets/custom_app_bar.dart';

final logger = Logger();

class VideoScreen extends StatefulWidget {
  final int id;
  final String? name;

  const VideoScreen({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  late final String controllerTag;
  late final VideoDetailController controller;

  @override
  void initState() {
    super.initState();

    controllerTag = genaratorLongVideoDetailTag(widget.id.toString());

    if (!Get.isRegistered<VideoDetailController>(tag: controllerTag)) {
      Get.lazyPut<VideoDetailController>(() => VideoDetailController(widget.id),
          tag: controllerTag);
    }

    controller = Get.find<VideoDetailController>(tag: controllerTag);
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete<VideoDetailController>(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videoUrl = controller.videoUrl.value;
      var video = controller.video.value;
      var videoDetail = controller.videoDetail.value;
      if (videoUrl.isEmpty) {
        return Container();
      }
      return VideoScreenWithVideoUrl(
          name: widget.name ?? '',
          videoDetail: videoDetail,
          video: video,
          videoUrl: videoUrl);
    });
  }
}

class VideoScreenWithVideoUrl extends StatefulWidget {
  final String name;
  final String videoUrl;
  final Vod? video;
  final Vod? videoDetail;
  const VideoScreenWithVideoUrl(
      {Key? key,
      this.video,
      this.videoDetail,
      required this.name,
      required this.videoUrl})
      : super(key: key);

  @override
  VideoScreenWithVideoUrlState createState() => VideoScreenWithVideoUrlState();
}

class VideoScreenWithVideoUrlState extends State<VideoScreenWithVideoUrl> {
  late ObservableVideoPlayerController observableVideoPlayerController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));

    if (!Get.isRegistered<ObservableVideoPlayerController>(
        tag: widget.videoUrl)) {
      Get.lazyPut<ObservableVideoPlayerController>(
          () => ObservableVideoPlayerController(
              const uuid.Uuid().v4(), widget.videoUrl),
          tag: widget.videoUrl);
    }

    observableVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant VideoScreenWithVideoUrl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoDetail != null && widget.video != null) {
      var playRecord = Vod(
        widget.video!.id,
        widget.video!.title,
        coverHorizontal: widget.video!.coverHorizontal!,
        coverVertical: widget.video!.coverVertical!,
        timeLength: widget.video!.timeLength!,
        tags: widget.video!.tags!,
        videoViewTimes: widget.videoDetail!.videoViewTimes!,
      );
      Get.find<PlayRecordController>(tag: 'vod').addPlayRecord(playRecord);
    }
  }

  @override
  void dispose() {
    observableVideoPlayerController.dispose();
    Get.delete<ObservableVideoPlayerController>(tag: widget.videoUrl);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          widget.video != null
              ? VideoPlayerArea(
                  name: widget.name,
                  videoUrl: widget.videoUrl,
                  video: widget.video!,
                )
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: CustomAppBar(
                      title: widget.name,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
          Expanded(
            child: widget.video != null && widget.videoDetail != null
                ? NestedTabBarView(
                    videoUrl: widget.videoUrl,
                    videoBase: widget.video!,
                    videoDetail: widget.videoDetail!,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
    );
  }
}
