// VideoPlayerWidget stateful widget
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/video.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:video_player/video_player.dart';

import '../base_video_player.dart';
import 'error.dart';
import 'loading.dart';
import 'progress.dart';

final logger = Logger();

class VideoPlayerWidget extends BaseVideoPlayerWidget {
  VideoPlayerWidget({required String videoUrl, required Video video})
      : super(videoUrl: videoUrl, video: video);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends BaseVideoPlayerWidgetState {
  bool isPlaying = false;
  bool isVisibleControls = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context, {VideoPlayerController? controller}) {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (hasError) ...[
            VideoError(
              coverHorizontal: widget.video.coverHorizontal ?? '',
              onTap: () {
                print('👹👹👹 onTap');
                controller?.play();
                setState(() {
                  hasError = false;
                });
              },
            ),
            Stack(
              children: [
                Container(
                  foregroundDecoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        const Color.fromARGB(255, 0, 34, 79),
                      ],
                      stops: const [0.8, 1.0],
                    ),
                  ),
                  child: SidImage(
                    key: ValueKey(widget.video.coverHorizontal ?? ''),
                    sid: widget.video.coverHorizontal ?? '',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller?.play();
                          setState(() {
                            hasError = false;
                          });
                        },
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 45.0,
                                semanticLabel: 'Play',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            )
          ] else if (controller != null && controller!.value.isInitialized) ...[
            VideoPlayer(controller),
            // controls
            GestureDetector(
              onTap: () {
                setState(() {
                  isVisibleControls = true;
                });
                Timer(const Duration(seconds: 3), () {
                  if (mounted) {
                    setState(() {
                      isVisibleControls = false;
                    });
                  }
                });
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: isVisibleControls
                    ? Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle),
                              child: IconButton(
                                icon: Icon(
                                  controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 48.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hasError = false;
                                  });
                                  setState(() {
                                    if (controller!.value.isPlaying) {
                                      controller!.pause();
                                      setState(() {
                                        isPause = true;
                                      });
                                    } else {
                                      controller!.play();
                                      setState(() {
                                        isPause = false;
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Stack(
                              children: <Widget>[
                                ValueListenableBuilder<VideoPlayerValue>(
                                  valueListenable: controller!,
                                  builder: (context, value, _) =>
                                      VideoProgressSlider(
                                    position: value.position,
                                    duration: value.duration,
                                    controller: controller!,
                                    swatch: const Color(0xffFFC700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ),
          ] else ...[
            VideoLoading(
              cover: widget.video.coverVertical ?? '',
            )
          ],
        ],
      ),
    );
  }
}
