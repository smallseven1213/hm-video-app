import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:volume_control/volume_control.dart';

import 'enums.dart';
import 'player_header.dart';
import 'screen_lock.dart';
import 'volume_brightness.dart';

final logger = Logger();

class ControlsOverlay extends StatefulWidget {
  final String videoUrl;
  final String? name;
  final Function toggleFullscreen;
  final bool isFullscreen;
  final Function onScreenLock;
  final bool isScreenLocked;
  const ControlsOverlay(
      {Key? key,
      this.name,
      required this.toggleFullscreen,
      required this.isFullscreen,
      required this.videoUrl,
      required this.onScreenLock,
      required this.isScreenLocked})
      : super(key: key);

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<ControlsOverlay> {
  bool hasH5FirstPlay = kIsWeb ? false : true;
  bool isForward = false;

  // vertical drag的東西
  double? initialVolume;
  double? initialBrightness;
  double? lastDragPosition; // 添加这一行
  double brightness = 0.5; // 初始值，表示亮度，範圍在 0.0 到 1.0 之間
  double volume = 0.5; // 初始值，表示音量，範圍在 0.0 到 1.0 之間
  SideControlsType sideControlsType = SideControlsType.none; // 初始值
  double verticalDragPosition = 0.0; // 初始值

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
      tag: widget.videoUrl,
      child: (videoPlayerInfo) =>
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
          onVerticalDragStart: (DragStartDetails details) {
            if (kIsWeb || !mounted) {
              return;
            }
            setState(() {
              // 根據滑動的開始位置來決定我們將要修改哪一個值
              if (details.localPosition.dx < constraints.maxWidth / 2) {
                // 如果用戶在畫面的左半邊開始滑動，那麼我們將會更新亮度的值
                sideControlsType = SideControlsType.brightness;
              } else {
                // 如果用戶在畫面的右半邊開始滑動，那麼我們將會更新音量的值
                sideControlsType = SideControlsType.sound;
              }
            });
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (!mounted || kIsWeb) {
              return;
            }
            lastDragPosition ??= details.globalPosition.dy;
            // 計算滑動距離並將其正規化到0到1之間
            double deltaY = details.globalPosition.dy - lastDragPosition!;
            verticalDragPosition -= deltaY / (constraints.maxHeight * 0.3);
            verticalDragPosition = verticalDragPosition.clamp(0.0, 1.0);

            // 檢查滑動是發生在畫面的左半邊還是右半邊
            bool isVolume = details.globalPosition.dx >
                MediaQuery.of(context).size.width / 2;
            if (isVolume) {
              volume = verticalDragPosition;
              volume = volume.clamp(0.0, 1.0);

              VolumeControl.setVolume(volume);
              videoPlayerInfo.videoPlayerController?.setVolume(volume);
              logger.i('volume: $volume');
            } else {
              brightness = verticalDragPosition;
              brightness = brightness.clamp(0.0, 1.0);
              ScreenBrightness().setScreenBrightness(brightness);
              logger.i('brightness: $brightness');
            }

            // 更新lastDragPosition以便于下次計算
            lastDragPosition = details.globalPosition.dy;
            setState(() {});
          },
          onVerticalDragEnd: (DragEndDetails details) {
            lastDragPosition = null;
            if (mounted && !kIsWeb) {
              setState(() {
                // 當用戶的手指離開螢幕時，我們需要將 sideControlsType 設回 SideControlsType.none
                sideControlsType = SideControlsType.none;
              });
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

            // Make sure we are within the video duration
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
              if (videoPlayerInfo.displayControls || !videoPlayerInfo.isPlaying)
                PlayerHeader(
                  isFullscreen: widget.isFullscreen,
                  title: widget.name,
                  toggleFullscreen: widget.toggleFullscreen,
                ),
              if (videoPlayerInfo.inBuffering && !videoPlayerInfo.isScrolling)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
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
              if (kIsWeb && !hasH5FirstPlay && !videoPlayerInfo.isPlaying)
                // 中間播放按鈕
                GestureDetector(
                  onTap: () {
                    videoPlayerInfo.videoPlayerController?.play();
                    if (kIsWeb && !hasH5FirstPlay) {
                      setState(() {
                        hasH5FirstPlay = true;
                      });
                    }
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
              if (videoPlayerInfo.displayControls || !videoPlayerInfo.isPlaying)
                // 下方控制區塊
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                              // trackShape: CustomTrackShape(),
                              trackHeight: 4.0, // 這可以設定滑塊軌道的高度
                              thumbShape: TransparentSliderThumbShape(),
                              activeTrackColor: Colors.blue, // 滑塊左邊（或上面）的部分的顏色
                              inactiveTrackColor: Colors.blue
                                  .withOpacity(0.3), // 滑塊右邊（或下面）的部分的顏色
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
                        kIsWeb
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

              //  垂直拖拉：顯示音量或亮度，並顯示音量或亮度的數值，拖拉位置在右邊時左邊顯示音量，拖拉位置在左邊時右邊顯示亮度
              if (!GetPlatform.isWeb &&
                      sideControlsType == SideControlsType.brightness ||
                  sideControlsType == SideControlsType.sound)
                VolumeBrightness(
                  controller: videoPlayerInfo.videoPlayerController!,
                  verticalDragPosition: verticalDragPosition,
                  sideControlsType: sideControlsType,
                  height: constraints.maxHeight,
                )
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
    final Paint paintThumb = Paint()..color = Colors.transparent; // 设置为透明色

    canvas.drawCircle(
      center,
      thumbRadius * enableAnimation.value,
      paintThumb,
    );
  }
}
