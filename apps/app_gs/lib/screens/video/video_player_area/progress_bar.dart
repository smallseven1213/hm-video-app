import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import 'new_progress_bar.dart';

class ProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  final Function toggleFullscreen;
  final bool isFullscreen;
  final double opacity;
  final Function onDragUpdate;
  const ProgressBar({
    Key? key,
    required this.controller,
    required this.toggleFullscreen,
    required this.isFullscreen,
    required this.opacity,
    required this.onDragUpdate,
  }) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

final logger = Logger();

class _ProgressBarState extends State<ProgressBar> {
  late int position = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        var pos = widget.controller.value.position.toString();
        List<String> parts = pos.split('.')[0].split(':');

        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        int seconds = int.parse(parts[2]);

        Duration duration =
            Duration(hours: hours, minutes: minutes, seconds: seconds);
        int totalSeconds = duration.inSeconds;
        print('PD: initial position: $totalSeconds');
        setState(() {
          position = totalSeconds;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('PD: build position: $position');
    return Positioned(
      bottom: widget.isFullscreen ? 30 : 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: widget.opacity,
        duration: const Duration(milliseconds: 300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.controller,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () {
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                  },
                  icon: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 18,
                  ),
                );
              },
            ),
            Text(
              widget.controller.value.position.toString().split('.')[0],
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: NewProgressBar(
                test1: position.toString(),
                currentProgress: position.toDouble(),
                videoDuration:
                    widget.controller.value.duration.inSeconds.toDouble(),
                onDragUpdate: (newPositionInSeconds) {
                  widget.controller
                      .seekTo(Duration(seconds: newPositionInSeconds.toInt()));
                  widget.onDragUpdate();
                },
              ),
            ),
            const SizedBox(width: 5.0),
            Text(
              widget.controller.value.duration.toString().split('.')[0],
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              onPressed: () => widget.toggleFullscreen(),
              icon: Icon(
                  widget.isFullscreen
                      ? Icons.close_fullscreen_rounded
                      : Icons.fullscreen,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
