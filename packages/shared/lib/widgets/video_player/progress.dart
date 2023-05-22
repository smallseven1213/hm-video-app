import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

final logger = Logger();

class VideoProgressSlider extends StatelessWidget {
  const VideoProgressSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.controller,
    required this.swatch,
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;

  @override
  Widget build(BuildContext context) {
    final max = duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, max).toDouble();
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
            seedColor: swatch, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      child: SliderTheme(
        data: const SliderThemeData(
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
          trackHeight: 2,
          thumbColor: Color(0xffFFC700),
          inactiveTrackColor: Color(0xffffffff),
        ),
        child: Slider(
          min: 0,
          max: max,
          value: value,
          onChanged: (value) =>
              controller.seekTo(Duration(milliseconds: value.toInt())),
          onChangeStart: (_) => controller.pause(),
          onChangeEnd: (_) => controller.play(),
        ),
      ),
    );
  }
}
