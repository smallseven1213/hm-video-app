import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/video_player_controller.dart';
import '../../models/vod.dart';
import 'error.dart';
import 'progress.dart';

final logger = Logger();

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final Vod video;
  final String coverHorizontal;
  final String obsKey;

  const VideoPlayerWidget(
      {Key? key,
      required this.obsKey,
      required this.videoUrl,
      required this.video,
      required this.coverHorizontal})
      : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ObservableVideoPlayerController obsVideoPlayerController;

  @override
  void initState() {
    super.initState();

    obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.obsKey);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Future.delayed(const Duration(milliseconds: 500), () {
        //     if (mounted) {
        //       obsVideoPlayerController.play();
        //     }
        //   });
        // });
      } else {
        obsVideoPlayerController.play();
      }
    });
  }

  @override
  void dispose() {
    obsVideoPlayerController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Obx(() {
        if (!obsVideoPlayerController.isReady.value ||
            obsVideoPlayerController.videoPlayerController == null) {
          return const SizedBox.shrink();
        }

        Size videoSize =
            obsVideoPlayerController.videoPlayerController!.value.size;
        var aspectRatio =
            videoSize.width / (videoSize.height != 0 ? videoSize.height : 1);

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (obsVideoPlayerController.videoAction.value == 'error') ...[
              if (kIsWeb)
                Center(
                  child: Text(
                    obsVideoPlayerController.errorMessage.value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              VideoError(
                coverHorizontal: widget.coverHorizontal,
                onTap: () {
                  obsVideoPlayerController.videoPlayerController!.play();
                },
              ),
            ] else ...[
              if (kIsWeb) ...[
                VideoPlayer(obsVideoPlayerController.videoPlayerController!)
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
                                aspectRatio: obsVideoPlayerController
                                    .videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(obsVideoPlayerController
                                    .videoPlayerController!),
                              )),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: aspectRatio,
                        child: VideoPlayer(
                          obsVideoPlayerController.videoPlayerController!,
                        ),
                      ),
              ],
              // Controls
              GestureDetector(
                onTap: () {
                  obsVideoPlayerController.toggle();
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: obsVideoPlayerController.videoAction.value == 'pause'
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
            ],
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    VideoPlayerController videoController =
                        obsVideoPlayerController.videoPlayerController!;
                    // 取得影片總長度，並將其切分成100格
                    double videoLengthInSeconds =
                        videoController.value.duration.inSeconds.toDouble();
                    double oneTickInSeconds = videoLengthInSeconds / 500;

                    // 使用details.delta.dx來判斷滑動的方向
                    if (details.delta.dx > 0) {
                      // dx大於0，手勢向右滑動，快進
                      videoController.seekTo(videoController.value.position +
                          Duration(
                              seconds: (oneTickInSeconds * details.delta.dx)
                                  .round()));
                    } else if (details.delta.dx < 0) {
                      // dx小於0，手勢向左滑動，快退
                      videoController.seekTo(videoController.value.position +
                          Duration(
                              seconds: (oneTickInSeconds * details.delta.dx)
                                  .round()));
                    }
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.0),
                        height: 20,
                      ),
                      SizedBox(
                        height: 3,
                        child: ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable:
                              obsVideoPlayerController.videoPlayerController!,
                          builder: (context, value, _) =>
                              VideoProgressIndicator(
                            obsVideoPlayerController.videoPlayerController!,
                            allowScrubbing: true,
                            padding: const EdgeInsets.all(0),
                            colors: VideoProgressColors(
                              playedColor: const Color(0xffFFC700),
                              bufferedColor: Colors.grey,
                              backgroundColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        );
      }),
    );
  }
}
