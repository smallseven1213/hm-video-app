import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';

final logger = Logger();

class FullScreenControls extends StatefulWidget {
  final String videoUrl;
  final String? name;
  final Function toggleFullscreen;
  final bool isFullscreen;
  final ObservableVideoPlayerController ovpController;

  const FullScreenControls({
    Key? key,
    this.name,
    required this.toggleFullscreen,
    required this.isFullscreen,
    required this.videoUrl,
    required this.ovpController,
  }) : super(key: key);

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<FullScreenControls> {
  String videoDurationString = '';
  String videoPositionString = '';
  bool hasH5FirstPlay = kIsWeb ? false : true;
  bool isPlaying = false;
  bool isForward = false;
  bool inBuffering = false;
  int videoDuration = 0; // 影片總長度
  int videoPosition = 0; // 影片目前進度
  bool isScrolling = false; // 正在拖動影片
  bool displayControls = false; // 是否要呈現影片控制區塊
  Timer? toggleControlsTimer;

  // vertical drag的東西
  double? initialVolume;
  double? initialBrightness;
  double? lastDragPosition; // 添加这一行
  double brightness = 0.5; // 初始值，表示亮度，範圍在 0.0 到 1.0 之間
  double volume = 0.5; // 初始值，表示音量，範圍在 0.0 到 1.0 之間
  double verticalDragPosition = 0.0; // 初始值

  void startToggleControlsTimer() {
    if (toggleControlsTimer != null) {
      toggleControlsTimer!.cancel();
    }
    toggleControlsTimer = Timer(const Duration(seconds: 2), () {
      if (displayControls) {
        toggleDisplayControls();
      }
    });
  }

  @override
  void initState() {
    startToggleControlsTimer();
    widget.ovpController.videoPlayerController.addListener(() {
      if (mounted &&
          widget.ovpController.videoPlayerController.value.isInitialized) {
        setState(() {
          inBuffering =
              widget.ovpController.videoPlayerController.value.isBuffering;
          isPlaying =
              widget.ovpController.videoPlayerController.value.isPlaying;
          videoDurationString = widget
              .ovpController.videoPlayerController.value.duration
              .toString()
              .split('.')
              .first;
          videoDuration = widget
              .ovpController.videoPlayerController.value.duration.inSeconds
              .toInt();
          videoPositionString = widget
              .ovpController.videoPlayerController.value.position
              .toString()
              .split('.')
              .first;
          videoPosition = widget
              .ovpController.videoPlayerController.value.position.inSeconds
              .toInt();
        });
      }
    });
    super.initState();
  }

  void showControls() {
    if (mounted) {
      setState(() {
        displayControls = true;
      });
    }
  }

  // 主動更新影片進度
  void updateVideoPosition(Duration newPosition) {
    widget.ovpController.videoPlayerController.seekTo(newPosition);
  }

  void toggleDisplayControls() {
    if (mounted) {
      setState(() {
        displayControls = !displayControls;
      });
    }
  }

  void startScrolling() {
    if (mounted) {
      setState(() {
        isScrolling = true;
      });
    }
  }

  // Add a function to set isScrolling to false
  void stopScrolling() {
    if (mounted) {
      setState(() {
        isScrolling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          showControls();
          startToggleControlsTimer();
        },
        onDoubleTap: () {
          if (isPlaying) {
            widget.ovpController.videoPlayerController.pause();
          } else {
            widget.ovpController.videoPlayerController.play();
          }
        },
        onHorizontalDragStart: (details) {
          if (details.localPosition.dy > constraints.maxHeight - 30) {
            return;
          }
          if (mounted) {
            startScrolling();
            showControls();
          }
        },
        onHorizontalDragUpdate: (details) {
          if (!mounted ||
              details.localPosition.dy > constraints.maxHeight - 30) {
            return;
          }
          double dragPercentage = details.delta.dx /
              (MediaQuery.of(context).size.width * 0.3); // 计算滑动距离占屏幕宽度的比例
          int newPositionSeconds = videoPosition +
              (dragPercentage * videoDuration).toInt(); // 使用滑动比例来更新视频位置

          // Make sure we are within the video duration
          if (newPositionSeconds < 0) newPositionSeconds = 0;
          if (newPositionSeconds > videoDuration) {
            newPositionSeconds = videoDuration;
          }

          updateVideoPosition(Duration(seconds: newPositionSeconds));
        },
        onHorizontalDragEnd: (details) {
          stopScrolling();
          startToggleControlsTimer();
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
            if (displayControls || !isPlaying)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  title: const Text(''),
                  elevation: 0,
                  centerTitle: false,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                    onPressed: () => widget.toggleFullscreen(),
                  ),
                ),
              ),
            if (inBuffering && !isScrolling)
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
            if (kIsWeb && !hasH5FirstPlay && !isPlaying)
              // 中間播放按鈕
              GestureDetector(
                onTap: () {
                  widget.ovpController.videoPlayerController.play();
                  if (kIsWeb && !hasH5FirstPlay) {
                    setState(() {
                      hasH5FirstPlay = true;
                    });
                  }
                },
                child: const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(
                      image: AssetImage('assets/images/short_play_button.png'),
                    ),
                  ),
                ),
              ),
            if (displayControls || !isPlaying)
              // 下方控制區塊
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          isPlaying
                              ? widget.ovpController.videoPlayerController
                                  .pause()
                              : widget.ovpController.videoPlayerController
                                  .play();
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
                      Expanded(
                        // 使用Expanded讓SliderTheme填充剩餘的空間
                        child: SliderTheme(
                          data: SliderThemeData(
                            // trackShape: CustomTrackShape(),
                            trackHeight: 4.0, // 這可以設定滑塊軌道的高度
                            thumbShape: TransparentSliderThumbShape(),
                            activeTrackColor: Colors.blue, // 滑塊左邊（或上面）的部分的顏色
                            inactiveTrackColor:
                                Colors.blue.withOpacity(0.3), // 滑塊右邊（或下面）的部分的顏色
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 0.0),
                          ),
                          child: Slider(
                            value: videoPosition.toDouble(),
                            min: 0,
                            max: videoDuration.toDouble(),
                            onChanged: (double value) {
                              if (mounted) {
                                startScrolling();
                                showControls();
                                updateVideoPosition(
                                    Duration(seconds: value.toInt()));
                              }
                            },
                            onChangeEnd: (double value) {
                              stopScrolling();
                              startToggleControlsTimer();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        videoDurationString,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 15.0),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx + 5;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width - 5;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class TransparentSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  TransparentSliderThumbShape({this.thumbRadius = 6.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paintThumb = Paint()..color = Colors.transparent; // 设置为透明色

    canvas.drawCircle(
      center,
      thumbRadius * enableAnimation.value,
      paintThumb,
    );
  }
}
