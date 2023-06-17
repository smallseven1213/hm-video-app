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
    this.trackHeight,
    this.onChangeStart,
    this.onChangeEnd,
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final Color swatch;
  final double? trackHeight;
  final void Function(double)? onChangeStart;
  final void Function(double)? onChangeEnd;

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
        data: SliderThemeData(
          trackShape: const RectangularSliderTrackShape(),
          trackHeight: trackHeight ?? 2,
          thumbColor: const Color(0xffFFC700),
          inactiveTrackColor: const Color(0xffffffff),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
        ),
        child: Slider(
            min: 0,
            max: max,
            value: value,
            thumbColor: Colors.transparent,
            onChanged: (value) =>
                controller.seekTo(Duration(milliseconds: value.toInt())),
            onChangeStart: (_) {
              onChangeStart?.call(value);
              // controller.pause();
            },
            onChangeEnd: (_) {
              onChangeEnd?.call(value);
              // controller.play();
            }),
      ),
    );
  }
}
