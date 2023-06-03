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
  final bool isActive;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.video,
    required this.isActive,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ObservableVideoPlayerController obsVideoPlayerController;

  @override
  void initState() {
    super.initState();

    obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);

    // if (widget.isActive == true &&
    //     obsVideoPlayerController.videoAction.value == 'pause') {
    //   obsVideoPlayerController.play();
    // } else {
    //   obsVideoPlayerController.pause();
    // }
  }

  // if mounted, exec play()
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.isActive == true &&
        obsVideoPlayerController.videoAction.value == 'pause') {
      obsVideoPlayerController.play();
    } else {
      obsVideoPlayerController.pause();
    }
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive == true &&
        obsVideoPlayerController.videoAction.value == 'pause') {
      obsVideoPlayerController.play();
    } else {
      obsVideoPlayerController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Obx(() {
        if (!obsVideoPlayerController.isReady.value) {
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
              // Text and return a error wording
              Center(
                child: Text(
                  obsVideoPlayerController.errorMessage.value,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              // VideoError(
              //   coverHorizontal: obsVideoPlayerController..coverHorizontal ?? '',
              //   onTap: () {
              //     toggleAction();
              //   },
              // ),
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
              bottom: -22,
              left: -24,
              right: -24,
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable:
                    obsVideoPlayerController.videoPlayerController!,
                builder: (context, value, _) => VideoProgressSlider(
                  controller: obsVideoPlayerController.videoPlayerController!,
                  position: value.position,
                  duration: value.duration,
                  swatch: const Color(0xffFFC700),
                ),
              ),
            ),
            if (kIsWeb)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Text(
                  obsVideoPlayerController.videoAction.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
