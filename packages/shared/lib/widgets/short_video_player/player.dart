import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/video_player_controller.dart';
import '../../localization/shared_localization_delegate.dart';
import '../../models/vod.dart';
import 'error.dart';

final logger = Logger();

class VideoPlayerDisplayWidget extends StatelessWidget {
  final ObservableVideoPlayerController controller;
  final Vod video;
  final Function toggleFullscreen;
  final bool? allowFullsreen;

  VideoPlayerDisplayWidget({
    super.key,
    required this.controller,
    required this.video,
    required this.toggleFullscreen,
    this.allowFullsreen = true,
  });

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    if (controller.videoPlayerController == null) {
      return Container();
    }
    Size videoSize = controller.videoPlayerController!.value.size;
    double aspectRatio = (video.aspectRatio != null && video.aspectRatio != 0)
        ? (1 / video.aspectRatio!) // 取倒数以符合AspectRatio的要求
        : (videoSize.height != 0 ? videoSize.width / videoSize.height : 1);

    return Container(
      color: Colors.black,
      child: Obx(() {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (controller.videoAction.value == 'error') ...[
              VideoError(
                videoCover: video.coverVertical!,
                errorMessage: controller.errorMessage.value,
                onTap: () {
                  controller.videoPlayerController?.play();
                },
              ),
            ] else if (controller.videoPlayerController?.value.isInitialized ==
                true) ...[
              if (kIsWeb) ...[
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(
                    controller.videoPlayerController!,
                  ),
                ),
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
                                aspectRatio: aspectRatio,
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

              // 控制层
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
                        ? const Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/short_play_button.png'),
                              ),
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
                    onPressed: () => toggleFullscreen(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          const Color(0xFF0e0e0e).withOpacity(0.5), // 文本和图标颜色
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10), // 内边距
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // 圆角半径
                        side: const BorderSide(
                            color: Color(0xFF353535), width: 0.5), // 边框
                      ),
                    ),
                    icon: const Icon(
                      Icons.screen_rotation_rounded,
                      size: 15.0, // 图标大小
                    ),
                    label: Text(
                      localizations.translate('fullscreen_view'),
                      style: const TextStyle(
                        fontSize: 12, // 字体大小
                        color: Color(0xFFE7E7E7), // 字体颜色
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
