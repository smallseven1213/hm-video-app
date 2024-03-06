import 'package:app_ra/screens/video/video_player_area/video_cover.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/float_page_back_button.dart';

final logger = Logger();

class VideoError extends StatelessWidget {
  final String coverHorizontal;
  final Function() onTap;

  const VideoError({
    Key? key,
    required this.coverHorizontal,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoCover(coverHorizontal: coverHorizontal),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onTap,
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
            ],
          ),
        ),
        const FloatPageBackButton(),
      ],
    );
  }
}
