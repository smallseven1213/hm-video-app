import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/short_video_detail_controller.dart';
import '../controllers/video_player_controller.dart';
import '../utils/controller_tag_genarator.dart';

class VideoProvider extends StatelessWidget {
  final int vodId;
  final Widget child;

  const VideoProvider({Key? key, required this.child, required this.vodId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTag = genaratorShortVideoDetailTag(vodId.toString());
    Get.lazyPut<ShortVideoDetailController>(
        () => ShortVideoDetailController(vodId),
        tag: controllerTag);

    final controller = Get.find<ShortVideoDetailController>(tag: controllerTag);

    return FutureBuilder(
      future: controller.videoUrlReady,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Get.lazyPut<ObservableVideoPlayerController>(
              () => ObservableVideoPlayerController(controller.videoUrl.value),
              tag: controller.videoUrl.value,
            );
            return child;
          }
        } else {
          return Container();
        }
      },
    );
  }
}
