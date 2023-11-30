import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerLayout extends StatefulWidget {
  final Uri uri;

  const PlayerLayout({Key? key, required this.uri}) : super(key: key);

  @override
  _PlayerLayoutState createState() => _PlayerLayoutState();
}

class _PlayerLayoutState extends State<PlayerLayout> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(widget.uri)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    // if UI ready, then play
    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: VideoPlayer(videoController),
    );
  }
}
