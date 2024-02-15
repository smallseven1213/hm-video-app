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
  int attemptCount = 0; // Keep track of attempts to play the video

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  void initializeVideoPlayer() {
    videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.uri.toString()))
          ..initialize().then((_) {
            setState(() {
              hasError = false; // Reset error flag on successful initialization
            });
            attemptToPlayVideo();
          }).catchError((error) {
            handleVideoError();
          });
  }

  void attemptToPlayVideo() {
    if (attemptCount < 3) {
      // Limit attempts to play the video
      videoController.play().catchError((error) {
        handleVideoError();
      });
    } else {
      setState(() {
        hasError = true; // Set error flag after exceeding attempts
      });
      // Optionally, provide user feedback here (e.g., a Snackbar)
    }
  }

  void handleVideoError() {
    setState(() {
      attemptCount += 1; // Increment attempt count
      hasError = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        if (attemptCount >= 3) {
          // Attempt to reinitialize if multiple play attempts fail
          initializeVideoPlayer();
        } else {
          attemptToPlayVideo();
        }
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
          'Error loading video. Attempting to fix...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: videoController.value.isInitialized
          ? OverflowBox(
              minWidth: 0.0,
              minHeight: 0.0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoController.value.size?.width ?? 0,
                  height: videoController.value.size?.height ?? 0,
                  child: VideoPlayer(videoController),
                ),
              ),
            )
          : const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
    );
  }
}
