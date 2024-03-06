import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const VideoProgressWidget({
    super.key,
    required this.videoPlayerController,
  });

  @override
  VideoProgressWidgetState createState() => VideoProgressWidgetState();
}

class VideoProgressWidgetState extends State<VideoProgressWidget> {
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) => setState(() {
        // isDragging = true;
      }),
      onPointerUp: (details) => setState(() {
        // isDragging = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isDragging ? 22 : 20,
        child: VideoProgressIndicator(
          widget.videoPlayerController,
          allowScrubbing: true,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          colors: VideoProgressColors(
            playedColor: const Color(0xFFFDDCEF),
            bufferedColor: Colors.grey,
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
