import 'package:flutter/material.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:video_player/video_player.dart';

class VideoProgressWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final int videoId;
  final String tag;

  const VideoProgressWidget({
    super.key,
    required this.videoPlayerController,
    required this.videoId,
    required this.tag,
  });

  @override
  VideoProgressWidgetState createState() => VideoProgressWidgetState();
}

class VideoProgressWidgetState extends State<VideoProgressWidget> {
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    return ShortVideoConsumer(
      vodId: widget.videoId,
      tag: widget.tag,
      child: ({
        required isLoading,
        required video,
        required videoDetail,
        required videoUrl,
      }) =>
          VideoPlayerConsumer(
        tag: widget.tag,
        child: (VideoPlayerInfo videoPlayerInfo) => Listener(
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
              videoPlayerInfo.videoPlayerController!,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              colors: VideoProgressColors(
                playedColor: const Color(0xFFFDDCEF),
                bufferedColor: Colors.grey,
                backgroundColor: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
