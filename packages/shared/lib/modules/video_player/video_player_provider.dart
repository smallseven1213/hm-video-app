import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/video_player_controller.dart';
import '../../models/vod.dart';

class VideoPlayerProvider extends StatefulWidget {
  final String tag;
  final String videoUrl;
  final Vod? video;
  final Vod videoDetail;
  final bool? autoPlay;
  final bool? shouldMuteByDefault;
  final Widget Function(
      bool isReady, ObservableVideoPlayerController controller) child;
  final Widget? loadingWidget;
  final ObservableVideoPlayerController? controller;

  const VideoPlayerProvider({
    Key? key,
    required this.tag,
    required this.videoUrl,
    this.video,
    required this.videoDetail,
    required this.child,
    this.loadingWidget,
    this.autoPlay,
    this.shouldMuteByDefault = true,
    this.controller,
  }) : super(key: key);

  @override
  VideoPlayerProviderState createState() => VideoPlayerProviderState();
}

class VideoPlayerProviderState extends State<VideoPlayerProvider> {
  late final ObservableVideoPlayerController observableVideoPlayerController;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      observableVideoPlayerController = widget.controller!;
    } else {
      observableVideoPlayerController = Get.put(
        ObservableVideoPlayerController(
          widget.tag,
          widget.videoUrl,
          widget.autoPlay ?? false,
          widget.shouldMuteByDefault ?? true,
        ),
        tag: widget.tag,
      );
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      observableVideoPlayerController.dispose();
      Get.delete<ObservableVideoPlayerController>(tag: widget.tag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => observableVideoPlayerController.isReady.value
          ? widget.child(observableVideoPlayerController.isReady.value,
              observableVideoPlayerController)
          : widget.loadingWidget ?? Container(),
    );
  }
}
