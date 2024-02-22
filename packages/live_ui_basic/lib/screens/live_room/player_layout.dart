import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerLayout extends StatefulWidget {
  final Uri uri;

  const PlayerLayout({Key? key, required this.uri}) : super(key: key);

  @override
  _PlayerLayoutState createState() => _PlayerLayoutState();
}

class _PlayerLayoutState extends State<PlayerLayout>
    with WidgetsBindingObserver {
  late VideoPlayerController videoController;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  void initializeVideoPlayer() {
    videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.uri.toString()))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                hasError = false;
              });
              videoController.play();
            }
          }).catchError((error) {
            if (mounted) {
              setState(() {
                hasError = true;
              });
              handleVideoError();
            }
          });

    videoController.addListener(() {
      if (videoController.value.hasError) {
        setState(() {
          hasError = true;
        });
        handleVideoError();
      }
    });
  }

  void handleVideoError() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // 重新初始化視頻播放器
        initializeVideoPlayer();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // 應用進入背景，暫停視頻
      videoController.pause();
    } else if (state == AppLifecycleState.resumed) {
      // 應用返回前台，重新初始化視頻播放器
      initializeVideoPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const Text(
          'Error loading video. Attempting to reconnect...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: videoController.value.isInitialized
          ? VideoPlayer(videoController)
          : const CircularProgressIndicator(),
    );
  }
}
