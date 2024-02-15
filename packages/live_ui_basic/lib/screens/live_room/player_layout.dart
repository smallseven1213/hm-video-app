import 'package:flutter/foundation.dart';
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
  bool hasError = false; // Flag to indicate if there's an error

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(widget.uri)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        // Handle initialization error
        setState(() {
          hasError = true;
        });
      });

    videoController.addListener(() {
      if (videoController.value.hasError) {
        // Update state if there's an error during video playback
        setState(() {
          hasError = true;
        });
        Future.delayed(Duration(seconds: 5), () {
          if (mounted && hasError) {
            videoController.play();
            setState(() {});
          }
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasError) {
        videoController.play();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const Text(
          'Error loading video',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (kIsWeb) {
      return Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: VideoPlayer(videoController),
      );
    }
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: OverflowBox(
        minWidth: 0.0,
        minHeight: 0.0,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: videoController.value.size.width,
            height: videoController.value.size.height,
            child: VideoPlayer(videoController),
          ),
        ),
      ),
    );
  }
}
