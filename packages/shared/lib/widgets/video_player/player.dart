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
    Size videoSize = controller.videoPlayerController.value.size;
    var aspectRatio =
        videoSize.width / (videoSize.height != 0 ? videoSize.height : 1);

    print('videoSize: ${videoSize.height} / ${videoSize.width}');

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
                  controller.videoPlayerController.play();
                },
              ),
            ] else if (controller
                .videoPlayerController.value.isInitialized) ...[
              if (kIsWeb) ...[
                VideoPlayer(controller.videoPlayerController)
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
                                    .videoPlayerController.value.aspectRatio,
                                child: VideoPlayer(
                                    controller.videoPlayerController),
                              )),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: aspectRatio,
                        child: VideoPlayer(
                          controller.videoPlayerController,
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
              if (videoSize.width > videoSize.height)
                Positioned(
                  bottom: 150,
                  child: Center(
                      child: ElevatedButton.icon(
                    onPressed: () => controller.toggleFullScreen(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color(0xFF0e0e0e).withOpacity(0.5), // 文本和圖示顏色
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10), // 內間距
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // 圓角半徑
                        side: const BorderSide(
                            color: Color(0xFF353535), width: 0.5), // 邊框
                      ),
                    ),
                    icon: const Icon(
                      Icons.screen_rotation_rounded,
                      size: 15.0, // 圖示大小
                    ),
                    label: const Text(
                      '全屏觀看',
                      style: TextStyle(
                        fontSize: 12, // 字體大小
                        color: Color(0xFFE7E7E7), // 字體顏色
                      ),
                    ),
                  )),
                ),
            ],
          ],
        );
      }),
    );
  }
}
