import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/widgets/video/controls_overlay/enums.dart';

import 'screen_lock.dart';
import 'player_header.dart';
import 'mute_volume_button.dart';

final logger = Logger();

class ControlsOverlay extends StatefulWidget {
  final String? name;
  final Function toggleFullscreen;
  final bool isFullscreen;
  final Function onScreenLock;
  final bool isScreenLocked;
  final String tag;
  final bool? displayHeader;
  final bool? displayFullScreenIcon;
  final Color? themeColor;
  final bool? isVerticalDragEnabled;

  const ControlsOverlay({
    Key? key,
    this.name,
    required this.toggleFullscreen,
    required this.isFullscreen,
    required this.onScreenLock,
    required this.isScreenLocked,
    required this.tag,
    this.displayHeader = true,
    this.displayFullScreenIcon = true,
    this.themeColor = Colors.blue,
    this.isVerticalDragEnabled = false,
  }) : super(key: key);

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<ControlsOverlay> {
  bool hasFirstPlay = true;
  bool isForward = false;

  // vertical drag的東西
  double? lastDragPosition; // 添加这一行
  bool isMuted = kIsWeb ? true : false; // 音量静音状态跟踪
  double brightness = 0.5; // 初始值，表示亮度，範圍在 0.0 到 1.0 之間
  double volume = 0.5; // 初始值，表示音量，範圍在 0.0 到 1.0 之間
  SideControlsType sideControlsType = SideControlsType.none; // 初始值
  double verticalDragPosition = 0.0; // 初始值
  bool initPost = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
      tag: widget.tag,
      child: (VideoPlayerInfo videoPlayerInfo) =>
          LayoutBuilder(builder: (context, constraints) {
        if (videoPlayerInfo.videoPlayerController == null) {
          return Container();
        }
        return GestureDetector(
          onTap: () {
            videoPlayerInfo.showControls();
            videoPlayerInfo.startToggleControlsTimer();
          },
          onDoubleTap: () {
            if (videoPlayerInfo.isPlaying) {
              videoPlayerInfo.videoPlayerController?.pause();
            } else {
              videoPlayerInfo.videoPlayerController?.play();
            }
          },
          onHorizontalDragStart: (details) {
            if (details.localPosition.dy > constraints.maxHeight - 30) {
              return;
            }
            if (mounted) {
              videoPlayerInfo.startScrolling();
              videoPlayerInfo.showControls();
            }
          },
          onHorizontalDragUpdate: (details) {
            if (!mounted ||
                details.localPosition.dy > constraints.maxHeight - 30) {
              return;
            }
            double dragPercentage = details.delta.dx /
                (MediaQuery.of(context).size.width * 0.3); // 计算滑动距离占屏幕宽度的比例
            int newPositionSeconds = videoPlayerInfo.videoPosition +
                (dragPercentage * videoPlayerInfo.videoDuration)
                    .toInt(); // 使用滑动比例来更新视频位置

            // 確保拖動位置在範圍內
            if (newPositionSeconds < 0) newPositionSeconds = 0;
            if (newPositionSeconds > videoPlayerInfo.videoDuration) {
              newPositionSeconds = videoPlayerInfo.videoDuration;
            }
            videoPlayerInfo.videoPlayerController
                ?.seekTo(Duration(seconds: newPositionSeconds));
          },
          onHorizontalDragEnd: (details) {
            videoPlayerInfo.stopScrolling();
            videoPlayerInfo.startToggleControlsTimer();
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
              if (widget.displayHeader == true &&
                  (videoPlayerInfo.displayControls ||
                      !videoPlayerInfo.isPlaying))
                PlayerHeader(
                  isFullscreen: widget.isFullscreen,
                  title: widget.name,
                  toggleFullscreen: widget.toggleFullscreen,
                ),
              if (widget.displayHeader == true &&
                  (videoPlayerInfo.displayControls ||
                      !videoPlayerInfo.isPlaying))
                Positioned(
                  top: 50,
                  left: 20,
                  child: MuteVolumeButton(
                      controller:
                          videoPlayerInfo.observableVideoPlayerController),
                ),
              if (videoPlayerInfo.inBuffering && !videoPlayerInfo.isScrolling)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (videoPlayerInfo.isScrolling)
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
                          text: videoPlayerInfo.videoPositionString,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${videoPlayerInfo.videoDurationString}',
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
              if (hasFirstPlay && !videoPlayerInfo.isPlaying)
                // 中間播放按鈕
                GestureDetector(
                  onTap: () {
                    videoPlayerInfo.videoPlayerController?.play();
                    setState(() {
                      if (hasFirstPlay) {
                        hasFirstPlay = false;
                        initPost = false;
                      }
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
              if (widget.isFullscreen &&
                  !kIsWeb &&
                  videoPlayerInfo.displayControls)
                ScreenLock(
                    isScreenLocked: widget.isScreenLocked,
                    onScreenLock: widget.onScreenLock),
              if ((videoPlayerInfo.displayControls ||
                      !videoPlayerInfo.isPlaying) &&
                  !initPost)
                // 下方控制區塊
                Positioned(
                  bottom: widget.isFullscreen ? 30 : 0,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            videoPlayerInfo.isPlaying
                                ? videoPlayerInfo.videoPlayerController?.pause()
                                : videoPlayerInfo.videoPlayerController?.play();
                          },
                          icon: Icon(
                            videoPlayerInfo.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        Text(
                          videoPlayerInfo.videoPositionString,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          // 使用Expanded讓SliderTheme填充剩餘的空間
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4.0, // 這可以設定滑塊軌道的高度
                              thumbShape: TransparentSliderThumbShape(),
                              activeTrackColor: widget.themeColor,
                              inactiveTrackColor: widget.themeColor!
                                  .withOpacity(0.5), // 滑塊右邊（或下面）的部分的顏色
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 0.0),
                            ),
                            child: Slider(
                              value: videoPlayerInfo.videoPosition.toDouble(),
                              min: 0,
                              max: videoPlayerInfo.videoDuration.toDouble(),
                              onChanged: (double value) {
                                if (mounted) {
                                  videoPlayerInfo.startScrolling();
                                  videoPlayerInfo.showControls();
                                  videoPlayerInfo.videoPlayerController?.seekTo(
                                      Duration(seconds: value.toInt()));
                                }
                              },
                              onChangeEnd: (double value) {
                                videoPlayerInfo.stopScrolling();
                                videoPlayerInfo.startToggleControlsTimer();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          videoPlayerInfo.videoDurationString,
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => videoPlayerInfo
                              .observableVideoPlayerController
                              .toggleMute(),
                          icon: Icon(
                            videoPlayerInfo.observableVideoPlayerController
                                    .isMuted.value
                                ? Icons.volume_off
                                : Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),
                        if (widget.displayFullScreenIcon == true)
                          kIsWeb && widget.isFullscreen
                              ? const SizedBox(width: 8.0)
                              : IconButton(
                                  onPressed: () => widget
                                      .toggleFullscreen(!widget.isFullscreen),
                                  icon: Icon(
                                    widget.isFullscreen
                                        ? Icons.close_fullscreen_rounded
                                        : Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
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
    final Paint paintThumb = Paint()..color = Colors.transparent;

    canvas.drawCircle(
      center,
      thumbRadius * enableAnimation.value,
      paintThumb,
    );
  }
}
