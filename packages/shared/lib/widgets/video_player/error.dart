import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/video_player/video_cover.dart';

import '../float_page_back_button.dart';

final logger = Logger();

class VideoError extends StatelessWidget {
  final String videoCover;
  final String errorMessage;
  final Function() onTap;

  const VideoError({
    Key? key,
    required this.videoCover,
    required this.errorMessage,
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
              GestureDetector(
                onTap: onTap,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.transparent,
                    child: const Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image(
                          image:
                              AssetImage('assets/images/short_play_button.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (kIsWeb)
          Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        const FloatPageBackButton(),
      ],
    );
  }
}
