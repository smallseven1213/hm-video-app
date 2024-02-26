import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:live_core/widgets/room_payment_check.dart';
import 'package:video_player/video_player.dart';

class PlayerLayout extends StatefulWidget {
  final Uri uri;
  final int pid;

  const PlayerLayout({Key? key, required this.uri, required this.pid})
      : super(key: key);

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

    return Stack(
      children: [
        Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: videoController.value.isInitialized
              ? VideoPlayer(videoController)
              : const CircularProgressIndicator(),
        ),
        RoomPaymentCheck(
            pid: widget.pid,
            child: (bool hasPermission) {
              return hasPermission
                  ? const SizedBox()
                  : Positioned.fill(
                      child: Center(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ));
            }),
      ],
    );
  }
}
