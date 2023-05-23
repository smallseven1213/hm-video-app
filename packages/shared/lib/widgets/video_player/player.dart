// VideoPlayerWidget stateful widget

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/video.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/video_player_controller.dart';
import 'error.dart';
import 'loading.dart';
import 'progress.dart';

final logger = Logger();

class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;
  final Video video;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isObsVideoPlayerControllerReady =
        Get.isRegistered<ObservableVideoPlayerController>(tag: videoUrl);
    logger.i(
        'RENDER OBX: VideoPlayerWidget isRegistered: $isObsVideoPlayerControllerReady');
    if (isObsVideoPlayerControllerReady) {
      final obsVideoPlayerController =
          Get.find<ObservableVideoPlayerController>(tag: videoUrl);
      logger.i('RENDER OBX: VideoPlayerWidget id: $videoUrl');

      return Container(
        color: Colors.black,
        child: Obx(
          () {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (obsVideoPlayerController.videoAction.value == 'error') ...[
                  // VideoError(
                  //   coverHorizontal: video.coverHorizontal ?? '',
                  //   onTap: () {
                  //     print('👹👹👹 onTap');
                  //     obsVideoPlayerController.play();
                  //   },
                  // ),
                  //
                ] else if (obsVideoPlayerController.isReady.value) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: VideoPlayer(
                        obsVideoPlayerController.videoPlayerController!),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: GestureDetector(
                      onTap: () {
                        obsVideoPlayerController.toggle();
                        // obsVideoPlayerController.setControls(true);
                        // Timer(const Duration(seconds: 3), () {
                        //   // if (mounted) {
                        //   //   obsVideoPlayerController.setControls(false);
                        //   // }
                        //   obsVideoPlayerController.setControls(false);
                        // });
                      },
                      child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: obsVideoPlayerController.videoAction.value ==
                                    'pause'
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: Icon(
                                        obsVideoPlayerController
                                                    .videoAction.value ==
                                                'pause'
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
                          )),
                      // child: obsVideoPlayerController.isVisibleControls.value
                      // ? Stack(
                      //     children: [
                      //       Center(
                      //         child: Container(
                      //           width: 100,
                      //           height: 100,
                      //           decoration: BoxDecoration(
                      //               color: Colors.black.withOpacity(0.5),
                      //               shape: BoxShape.circle),
                      //           child: IconButton(
                      //             icon: Icon(
                      //               obsVideoPlayerController
                      //                           .videoAction.value ==
                      //                       'pause'
                      //                   ? Icons.pause
                      //                   : Icons.play_arrow,
                      //               color: Colors.white,
                      //               size: 48.0,
                      //             ),
                      //             onPressed: () {
                      //               obsVideoPlayerController.toggle();
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   )
                      //     : const SizedBox()),
                    ),
                  ),
                ] else ...[
                  // VideoLoading(
                  //   cover: video.coverVertical ?? '',
                  // )
                ],
                Positioned(
                  bottom: -20,
                  left: -24,
                  right: -24,
                  child: ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable:
                        obsVideoPlayerController.videoPlayerController!,
                    builder: (context, value, _) => VideoProgressSlider(
                      controller:
                          obsVideoPlayerController.videoPlayerController!,
                      position: value.position,
                      duration: value.duration,
                      swatch: const Color(0xffFFC700),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
