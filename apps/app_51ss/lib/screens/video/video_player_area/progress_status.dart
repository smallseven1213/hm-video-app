import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProgressStatus extends StatelessWidget {
  final bool isForward;
  final VideoPlayerController controller;
  const ProgressStatus({
    super.key,
    required this.controller,
    required this.isForward,
  });

  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;
    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              text: formatDuration(controller.value.position),
              style: const TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ' / ${formatDuration(controller.value.duration)}',
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
    );
  }
}
