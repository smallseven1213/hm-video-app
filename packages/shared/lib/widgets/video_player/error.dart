import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/video_player/video_cover.dart';

final logger = Logger();

class VideoError extends StatelessWidget {
  final String videoCover;
  final Function() onTap;

  const VideoError({
    Key? key,
    required this.videoCover,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoCover(
          imageSid: videoCover,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}
