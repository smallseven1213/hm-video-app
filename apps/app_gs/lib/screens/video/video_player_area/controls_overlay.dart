import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';

import 'play_pause_button.dart';
import 'player_header.dart';
import 'volume_brightness.dart';

final logger = Logger();

class ControlsOverlay extends StatefulWidget {
  final String videoUrl;
  const ControlsOverlay({Key? key, required this.videoUrl}) : super(key: key);

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<ControlsOverlay> {
  late ObservableVideoPlayerController ovpController;
  String videoDurationString = '';
  String videoPositionString = '';
  bool displayAppBar = true;
  bool isPlaying = false;
  bool isForward = false;
  bool inBuffering = false;
  int videoDuration = 0; // 影片總長度
  int videoPosition = 0; // 影片目前進度
  bool isScrolling = false; // 正在拖動影片
  bool displayControls = false; // 是否要呈現影片控制區塊

  @override
  void initState() {
    ovpController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        displayAppBar = false;
      });
    });
    ovpController.videoPlayerController.addListener(() {
      if (mounted && ovpController.videoPlayerController.value.isInitialized) {
        setState(() {
          inBuffering = ovpController.videoPlayerController.value.isBuffering;
          isPlaying = ovpController.videoPlayerController.value.isPlaying;
          videoDurationString = ovpController
              .videoPlayerController.value.duration
              .toString()
              .split('.')
              .first;
          // 將videoDurationString的HH MM SS拆出來，最後換算成秒數
          List<String> durationList = videoDurationString.split(':');
          if (durationList.length == 3) {
            videoDuration = int.parse(durationList[0]) * 3600 +
                int.parse(durationList[1]) * 60 +
                int.parse(durationList[2]);
          } else if (durationList.length == 2) {
            videoDuration =
                int.parse(durationList[0]) * 60 + int.parse(durationList[1]);
          } else {
            videoDuration = int.parse(durationList[0]);
          }
          videoPositionString = ovpController
              .videoPlayerController.value.position
              .toString()
              .split('.')
              .first;
          videoPosition = ovpController
              .videoPlayerController.value.position.inSeconds
              .toInt();
        });
      }
    });
    super.initState();
  }

  void showControls() {
    setState(() {
      displayControls = true;
    });
  }

  // 主動更新影片進度
  void updateVideoPosition(Duration newPosition) {
    ovpController.videoPlayerController.seekTo(newPosition);
  }

  void toggleDisplayControls() {
    setState(() {
      displayControls = !displayControls;
    });
  }

  void startScrolling() {
    setState(() {
      isScrolling = true;
    });
  }

  // Add a function to set isScrolling to false
  void stopScrolling() {
    setState(() {
      isScrolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          showControls();
          Future.delayed(Duration(seconds: 2), () {
            if (displayControls && !isScrolling) {
              toggleDisplayControls();
            }
          });
        },
        onDoubleTap: () {
          if (isPlaying) {
            ovpController.videoPlayerController.pause();
          } else {
            ovpController.videoPlayerController.play();
          }
        },
        onHorizontalDragStart: (details) {
          startScrolling();
          showControls();
        },
        onHorizontalDragUpdate: (details) {
          int newPositionSeconds = videoPosition + details.delta.dx.toInt();
          // Make sure we are within the video duration
          if (newPositionSeconds < 0) newPositionSeconds = 0;
          if (newPositionSeconds > videoDuration) {
            newPositionSeconds = videoDuration;
          }

          updateVideoPosition(Duration(seconds: newPositionSeconds));
        },
        onHorizontalDragEnd: (details) {
          stopScrolling();
          Future.delayed(Duration(seconds: 2), () {
            if (displayControls) {
              toggleDisplayControls();
            }
          });
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                child: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  color: Colors.transparent,
                )),
            if (displayAppBar)
              PlayerHeader(
                isFullscreen: widget.isFullscreen,
                title: widget.name,
                toggleFullscreen: widget.toggleFullscreen,
              ),
            if (inBuffering)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            if (isScrolling)
              Center(
                child: RichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Icon(
                          isForward
                              ? Icons.keyboard_double_arrow_right
                              : Icons.keyboard_double_arrow_left,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                        text: videoPositionString,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' / $videoDurationString',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white.withOpacity(.75),
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (!isPlaying && !isScrolling && !inBuffering)
              // 中間播放按鈕
              InkWell(
                onTap: () {
                  ovpController.videoPlayerController.play();
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
            if (displayControls || !isPlaying)
              // 下方控制區塊
              Positioned(
                bottom: 0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        isPlaying
                            ? ovpController.videoPlayerController.pause()
                            : ovpController.videoPlayerController.play();
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    Text(
                      videoPositionString,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Slider(
                      value: videoPosition.toDouble(),
                      min: 0,
                      max: videoDuration.toDouble(),
                      onChanged: (double value) {
                        startScrolling();
                        showControls();
                        updateVideoPosition(Duration(seconds: value.toInt()));
                      },
                      onChangeEnd: (double value) {
                        stopScrolling();
                        Future.delayed(Duration(seconds: 2), () {
                          if (displayControls) {
                            toggleDisplayControls();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      videoDurationString,
                      style: const TextStyle(color: Colors.white),
                    ),
                    // IconButton(
                    //   onPressed: () => widget.toggleFullscreen(),
                    //   icon: Icon(
                    //       widget.isFullscreen
                    //           ? Icons.close_fullscreen_rounded
                    //           : Icons.fullscreen,
                    //       color: Colors.white),
                    // ),
                  ],
                ),
              ),

            //  垂直拖拉：顯示音量或亮度，並顯示音量或亮度的數值，拖拉位置在右邊時左邊顯示音量，拖拉位置在左邊時右邊顯示亮度
            // if (!GetPlatform.isWeb &&
            //         sideControlsType == SideControlsType.brightness ||
            //     sideControlsType == SideControlsType.sound)
            //   VolumeBrightness(
            //     controller: widget.controller,
            //     verticalDragPosition: verticalDragPosition,
            //     sideControlsType: sideControlsType,
            //     height: constraints.maxHeight,
            //   )
          ],
        ),
      );
    });
  }
}
