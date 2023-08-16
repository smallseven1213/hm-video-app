import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';

final logger = Logger();

class FullScreenControls extends StatefulWidget {
  final String? name;
  final VideoPlayerInfo videoPlayerInfo;

  const FullScreenControls({
    Key? key,
    this.name,
    required this.videoPlayerInfo,
  }) : super(key: key);

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<FullScreenControls> {
  bool hasH5FirstPlay = kIsWeb ? false : true;
  bool isForward = false;
  bool isScrolling = false; // 正在拖動影片

  Widget playPauseButton(videoPlayerInfo) {
    return GestureDetector(
      onTap: () {
        videoPlayerInfo.observableVideoPlayerController.toggle();
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: videoPlayerInfo
                      .observableVideoPlayerController.videoAction.value ==
                  'pause'
              ? const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image(
                      image: AssetImage('assets/images/short_play_button.png'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          widget.videoPlayerInfo.showControls();
          widget.videoPlayerInfo.startToggleControlsTimer();
        },
        onDoubleTap: () {
          if (widget.videoPlayerInfo.isPlaying) {
            widget.videoPlayerInfo.videoPlayerController?.pause();
          } else {
            widget.videoPlayerInfo.videoPlayerController?.play();
          }
        },
        onHorizontalDragStart: (details) {
          if (details.localPosition.dy > constraints.maxHeight - 30) {
            return;
          }
          if (mounted) {
            widget.videoPlayerInfo.startScrolling();
            widget.videoPlayerInfo.showControls();
          }

          setState(() {
            isScrolling = true;
          });
        },
        onHorizontalDragUpdate: (details) {
          if (!mounted ||
              details.localPosition.dy > constraints.maxHeight - 30) {
            return;
          }
          double dragPercentage = details.delta.dx /
              (MediaQuery.of(context).size.width * 0.3); // 计算滑动距离占屏幕宽度的比例
          int newPositionSeconds = widget.videoPlayerInfo.videoPosition +
              (dragPercentage * widget.videoPlayerInfo.videoDuration)
                  .toInt(); // 使用滑动比例来更新视频位置

          // Make sure we are within the video duration
          if (newPositionSeconds < 0) newPositionSeconds = 0;
          if (newPositionSeconds > widget.videoPlayerInfo.videoDuration) {
            newPositionSeconds = widget.videoPlayerInfo.videoDuration;
          }
          // check if we are fast forwarding or rewinding
          setState(() {
            isForward = details.delta.dx > 0;
          });
          widget.videoPlayerInfo.videoPlayerController
              ?.seekTo(Duration(seconds: newPositionSeconds));
        },
        onHorizontalDragEnd: (details) {
          widget.videoPlayerInfo.stopScrolling();
          widget.videoPlayerInfo.startToggleControlsTimer();
          setState(() {
            isScrolling = false;
          });
        },
        child: Stack(children: <Widget>[
          playPauseButton(widget.videoPlayerInfo),
          if (widget.videoPlayerInfo.inBuffering && !isScrolling)
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
                      text: widget.videoPlayerInfo.videoPositionString,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${widget.videoPlayerInfo.videoDurationString}',
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
          // progress bar
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.videoPlayerInfo.isPlaying
                          ? widget.videoPlayerInfo.videoPlayerController
                              ?.pause()
                          : widget.videoPlayerInfo.videoPlayerController
                              ?.play();
                    },
                    icon: Icon(
                      widget.videoPlayerInfo.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 18,
                    ),
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
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 0.0),
                      ),
                      child: Slider(
                        value: widget.videoPlayerInfo.videoPosition.toDouble(),
                        min: 0,
                        max: widget.videoPlayerInfo.videoDuration.toDouble(),
                        onChanged: (double value) {
                          if (mounted) {
                            widget.videoPlayerInfo.startScrolling();
                            widget.videoPlayerInfo.showControls();
                            widget.videoPlayerInfo.videoPlayerController
                                ?.seekTo(Duration(seconds: value.toInt()));
                          }
                        },
                        onChangeEnd: (double value) {
                          widget.videoPlayerInfo.stopScrolling();
                          widget.videoPlayerInfo.startToggleControlsTimer();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                ],
              ),
            ),
          ),
        ]),
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
