import 'package:app_ra/config/colors.dart';
import 'package:app_ra/screens/video/video_player_area/video_cover.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/color_keys.dart';

final logger = Logger();

class VideoLoading extends StatelessWidget {
  final String coverHorizontal;
  const VideoLoading({Key? key, required this.coverHorizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoCover(coverHorizontal: coverHorizontal),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.colors[ColorKeys.textPrimary],
              ),
              const SizedBox(height: 15),
              const Text(
                '精彩即將呈現',
                style: TextStyle(fontSize: 12, color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
  }
}
