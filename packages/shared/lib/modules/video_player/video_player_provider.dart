import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart' as uuid;
import '../../controllers/video_player_controller.dart';
import '../../models/vod.dart';

class VideoPlayerProvider extends StatefulWidget {
  final String tag;
  final String videoUrl;
  final Vod video;
  final Vod videoDetail;
  final bool? autoPlay;
  final Widget Function(bool isReady) child;
  final Widget? loadingWidget;

  const VideoPlayerProvider({
    Key? key,
    required this.tag,
    required this.videoUrl,
    required this.video,
    required this.videoDetail,
    required this.child,
    this.loadingWidget,
    this.autoPlay,
  }) : super(key: key);

  @override
  VideoPlayerProviderState createState() => VideoPlayerProviderState();
}

class VideoPlayerProviderState extends State<VideoPlayerProvider> {
  late final ObservableVideoPlayerController observableVideoPlayerController;

  @override
  void initState() {
    super.initState();

    observableVideoPlayerController = Get.put(
      ObservableVideoPlayerController(
        widget.tag,
        widget.videoUrl,
        widget.autoPlay ?? false,
      ),
      tag: widget.tag,
    );
  }

  @override
  void dispose() {
    observableVideoPlayerController.videoPlayerController?.dispose();
    // observableVideoPlayerController.dispose();
    // Get.delete<ObservableVideoPlayerController>(tag: widget.videoUrl);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var isReady = observableVideoPlayerController.isReady.value;
    return Obx(
      () => observableVideoPlayerController.isReady.value
          ? widget.child(observableVideoPlayerController.isReady.value)
          : widget.loadingWidget ?? Container(),
    );
  }
}
