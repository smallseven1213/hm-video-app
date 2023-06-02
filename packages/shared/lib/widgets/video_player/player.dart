import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/video_player_controller.dart';
import '../../models/vod.dart';
import 'progress.dart';

final logger = Logger();

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;
  final Vod video;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: videoUrl);

    if (obsVideoPlayerController == null) {
      logger.e('😡😡😡😡 obsVideoPlayerController is null');
      return const SizedBox.shrink();
    }

    VideoPlayerController? videoPlayerController =
        obsVideoPlayerController.videoPlayerController;

    return Container(
        color: Colors.black,
        child: Obx(
          () {
            if (!obsVideoPlayerController.isReady.value) {
              return const SizedBox.shrink();
            }

            var videoAction = obsVideoPlayerController.videoAction.value;

            Size videoSize = videoPlayerController!.value.size;
            var aspectRatio = videoSize.width /
                (videoSize.height != 0 ? videoSize.height : 1);

            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (videoAction == 'error') ...[
                  // VideoError(
                  //   coverHorizontal: video.coverHorizontal ?? '',
                  //   onTap: () {
                  //     obsVideoPlayerController.play();
                  //   },
                  // ),
                  //
                ] else ...[
                  if (kIsWeb) ...[
                    VideoPlayer(videoPlayerController)
                  ] else ...[
                    videoSize.height / videoSize.width >= 1.4
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                  width: videoSize.width,
                                  height: videoSize.height,
                                  child: AspectRatio(
                                    aspectRatio:
                                        videoPlayerController.value.aspectRatio,
                                    child: VideoPlayer(videoPlayerController),
                                  )),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: aspectRatio,
                            child: VideoPlayer(
                              videoPlayerController,
                            ),
                          ),
                  ],
                  // Controls
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: GestureDetector(
                      onTap: () {
                        obsVideoPlayerController.toggle();
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: videoAction == 'pause'
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: Icon(
                                      videoAction == 'pause'
                                          ? Icons.play_arrow
                                          : Icons.pause,
                                      color: Colors.white,
                                      size: 48.0,
                                    ),
                                    onPressed: () {
                                      obsVideoPlayerController.toggle();
                                    },
                                  ),
                                )
                              : const SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: SizedBox.shrink(),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
                Positioned(
                  bottom: -22,
                  left: -24,
                  right: -24,
                  child: ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: videoPlayerController,
                    builder: (context, value, _) => VideoProgressSlider(
                      controller: videoPlayerController,
                      position: value.position,
                      duration: value.duration,
                      swatch: const Color(0xffFFC700),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
