import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DraggableVideoProgressBar extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final Color playedColor;
  final Color bufferedColor;
  final Color backgroundColor;

  const DraggableVideoProgressBar({
    Key? key,
    required this.videoPlayerController,
    this.playedColor = const Color(0xffFFC700),
    this.bufferedColor = Colors.grey,
    this.backgroundColor = const Color(0xFFffffff),
  }) : super(key: key);

  @override
  _DraggableVideoProgressBarState createState() =>
      _DraggableVideoProgressBarState();
}

class _DraggableVideoProgressBarState extends State<DraggableVideoProgressBar> {
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        setState(() {
          isDragging = true;
        });
      },
      onPointerUp: (details) {
        setState(() {
          isDragging = false;
        });
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
              HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer(),
            (HorizontalDragGestureRecognizer instance) {
              instance
                ..onStart = (DragStartDetails details) {
                  // 可以处理拖动开始的事件
                }
                ..onUpdate = (DragUpdateDetails details) {
                  // 可以处理拖动更新的事件
                }
                ..onEnd = (DragEndDetails details) {
                  // 可以处理拖动结束的事件
                };
            },
          ),
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isDragging ? 40 : 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: VideoProgressIndicator(
              widget.videoPlayerController,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              colors: VideoProgressColors(
                playedColor: widget.playedColor,
                bufferedColor: widget.bufferedColor,
                backgroundColor: widget.backgroundColor.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
