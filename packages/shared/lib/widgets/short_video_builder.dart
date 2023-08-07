import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/short_video_detail_controller.dart';
import '../controllers/video_player_controller.dart';
import '../models/short_video_detail.dart';
import '../models/vod.dart';
import '../utils/controller_tag_genarator.dart';

final logger = Logger();

class ShortVideoBuilder extends StatefulWidget {
  final int vodId;
  final Widget child;
  final String obsKey;
  final Widget? loading;

  const ShortVideoBuilder({
    Key? key,
    required this.obsKey,
    required this.child,
    required this.vodId,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoBuilderState createState() => ShortVideoBuilderState();
}

class ShortVideoBuilderState extends State<ShortVideoBuilder> {
  late final String controllerTag;
  late final ShortVideoDetailController controller;

  @override
  void initState() {
    super.initState();

    controllerTag = genaratorShortVideoDetailTag(widget.vodId.toString());
    if (!Get.isRegistered(tag: controllerTag)) {
      Get.lazyPut<ShortVideoDetailController>(
          () => ShortVideoDetailController(widget.vodId),
          tag: controllerTag);
    }

    controller = Get.find<ShortVideoDetailController>(tag: controllerTag);
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videoUrl = controller.videoUrl.value;
      var video = controller.video.value;
      var videoDetail = controller.videoDetail.value;
      if (videoUrl.isEmpty) {
        return widget.loading ?? Container();
      }
      return VideoScreenWithVideoUrl(
          obsKey: widget.obsKey,
          videoDetail: videoDetail,
          video: video,
          videoUrl: videoUrl,
          child: widget.child);
    });
  }
}

class VideoScreenWithVideoUrl extends StatefulWidget {
  final Widget child;
  final String videoUrl;
  final String obsKey;
  final Vod? video;
  final ShortVideoDetail? videoDetail;
  const VideoScreenWithVideoUrl(
      {Key? key,
      required this.child,
      required this.obsKey,
      this.video,
      this.videoDetail,
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

    var ovpControllerKey = widget.obsKey;

    if (!Get.isRegistered<ObservableVideoPlayerController>(
        tag: ovpControllerKey)) {
      Get.lazyPut<ObservableVideoPlayerController>(
          () => ObservableVideoPlayerController(
              ovpControllerKey, widget.videoUrl),
          tag: ovpControllerKey);
    }

    observableVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: ovpControllerKey);
  }

  @override
  void dispose() {
    var ovpControllerKey = widget.obsKey;
    observableVideoPlayerController.dispose();
    Get.delete<ObservableVideoPlayerController>(tag: ovpControllerKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
