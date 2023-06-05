import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/short_video_detail_controller.dart';
import '../controllers/video_player_controller.dart';
import '../models/short_video_detail.dart';
import '../models/vod.dart';
import '../utils/controller_tag_genarator.dart';

class VideoProvider extends StatefulWidget {
  final int vodId;
  final Widget child;

  const VideoProvider({Key? key, required this.child, required this.vodId})
      : super(key: key);

  @override
  _VideoProviderState createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
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
    Get.delete(
        tag:
            controllerTag); // Deleting the controller when the widget is disposed
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
  final Vod? video;
  final ShortVideoDetail? videoDetail;
  const VideoScreenWithVideoUrl(
      {Key? key,
      required this.child,
      this.video,
      this.videoDetail,
      required this.videoUrl})
      : super(key: key);

  @override
  _VideoScreenWithVideoUrlState createState() =>
      _VideoScreenWithVideoUrlState();
}

class _VideoScreenWithVideoUrlState extends State<VideoScreenWithVideoUrl> {
  late ObservableVideoPlayerController observableVideoPlayerController;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ObservableVideoPlayerController>(
        tag: widget.videoUrl)) {
      Get.lazyPut<ObservableVideoPlayerController>(
          () => ObservableVideoPlayerController(widget.videoUrl),
          tag: widget.videoUrl);
    }

    observableVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);
  }

  @override
  void dispose() {
    observableVideoPlayerController.dispose();
    Get.delete<ObservableVideoPlayerController>(tag: widget.videoUrl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
