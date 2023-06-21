import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/video_player_controller.dart';
import '../../models/vod.dart';
import 'error.dart';

final logger = Logger();

class VideoPlayerDisplayWidget extends StatelessWidget {
  final ObservableVideoPlayerController controller;
  final Vod video;

  const VideoPlayerDisplayWidget({
    super.key,
    required this.controller,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    Size videoSize = controller.videoPlayerController!.value.size;
    var aspectRatio =
        videoSize.width / (videoSize.height != 0 ? videoSize.height : 1);

    return Container(
      color: Colors.black,
      child: Obx(() {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (controller.videoAction.value == 'error') ...[
              if (kIsWeb)
                Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              VideoError(
                videoCover: video.coverVertical!,
                onTap: () {
                  controller.videoPlayerController!.play();
                },
              ),
            ] else if (controller
                .videoPlayerController.value.isInitialized) ...[
              if (kIsWeb) ...[
                VideoPlayer(controller.videoPlayerController!)
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
                                aspectRatio: controller
                                    .videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(
                                    controller.videoPlayerController!),
                              )),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: aspectRatio,
                        child: VideoPlayer(
                          controller.videoPlayerController!,
                        ),
                      ),
              ],
              // Controls
              GestureDetector(
                onTap: () {
                  controller.toggle();
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: controller.videoAction.value == 'pause'
                        ? Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                            child: IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 48.0,
                              ),
                              onPressed: () {
                                controller.toggle();
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
            ],
          ],
        );
      }),
    );
  }
}
