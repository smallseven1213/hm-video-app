import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

final logger = Logger();

class VideoPlayerInfo {
  final ObservableVideoPlayerController observableVideoPlayerController;
  final VideoPlayerController? videoPlayerController;
  final bool isReady;
  final bool inBuffering;
  final bool isPlaying;
  final String videoDurationString;
  final int videoDuration;
  final String videoPositionString;
  final int videoPosition;
  final bool displayControls;
  final bool isScrolling;
  final Size videoSize;
  final String videoAction;
  final Function() showControls;
  final Function() startToggleControlsTimer;
  final Function() startScrolling;
  final Function() stopScrolling;
  final double volume;

  VideoPlayerInfo({
    required this.videoAction,
    required this.observableVideoPlayerController,
    required this.videoPlayerController,
    required this.isReady,
    required this.inBuffering,
    required this.isPlaying,
    required this.videoDurationString,
    required this.videoDuration,
    required this.videoPositionString,
    required this.videoPosition,
    required this.displayControls,
    required this.isScrolling,
    required this.videoSize,
    required this.showControls,
    required this.startToggleControlsTimer,
    required this.startScrolling,
    required this.stopScrolling,
    this.volume = 1.0,
  });
}

class VideoPlayerConsumer extends StatefulWidget {
  final String tag;
  final Widget Function(VideoPlayerInfo) child;
  const VideoPlayerConsumer({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

  @override
  VideoPlayerConsumerState createState() => VideoPlayerConsumerState();
}

class VideoPlayerConsumerState extends State<VideoPlayerConsumer> {
  late final ObservableVideoPlayerController ovpController;
  Timer? toggleControlsTimer;

  // 註冊下面有用到的state
  String videoAction = 'pause';
  bool isReady = false;
  bool inBuffering = false;
  bool isPlaying = false;
  String videoDurationString = '00:00:00';
  int videoDuration = 0;
  String videoPositionString = '00:00:00';
  int videoPosition = 0;
  bool displayControls = false;
  bool isScrolling = false;
  Size videoSize = const Size(0, 0);
  double volume = 1.0;

  @override
  void initState() {
    startToggleControlsTimer();
    ovpController = Get.find<ObservableVideoPlayerController>(tag: widget.tag);
    ovpController.videoPlayerController?.addListener(() {
      if (mounted && ovpController.videoPlayerController!.value.isInitialized) {
        setState(() {
          videoAction = ovpController.videoAction.value;
          isReady = ovpController.isReady.value;
          inBuffering = ovpController.videoPlayerController!.value.isBuffering;
          isPlaying = ovpController.videoPlayerController!.value.isPlaying;
          videoDurationString = ovpController
              .videoPlayerController!.value.duration
              .toString()
              .split('.')
              .first;
          videoDuration = ovpController
              .videoPlayerController!.value.duration.inSeconds
              .toInt();
          videoPositionString = ovpController
              .videoPlayerController!.value.position
              .toString()
              .split('.')
              .first;
          videoPosition = ovpController
              .videoPlayerController!.value.position.inSeconds
              .toInt();
          videoSize = ovpController.videoPlayerController!.value.size;
          volume = ovpController.videoPlayerController!.value.volume;
        });

        if (ovpController.videoPlayerController!.value.duration ==
            ovpController.videoPlayerController!.value.position) {
          setState(() {
            videoAction = 'end';
          });
        }
      }
    });
    super.initState();
  }

  void startToggleControlsTimer() {
    if (toggleControlsTimer != null) {
      toggleControlsTimer!.cancel();
    }
    toggleControlsTimer = Timer(const Duration(seconds: 5), () {
      if (displayControls) {
        toggleDisplayControls();
      }
    });
  }

  void toggleDisplayControls() {
    if (mounted) {
      setState(() {
        displayControls = !displayControls;
      });
    }
  }

  void startScrolling() {
    if (mounted) {
      setState(() {
        isScrolling = true;
      });
    }
  }

  // Add a function to set isScrolling to false
  void stopScrolling() {
    if (mounted) {
      setState(() {
        isScrolling = false;
      });
    }
  }

  void showControls() {
    if (mounted) {
      setState(() {
        displayControls = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(
      VideoPlayerInfo(
        videoAction: videoAction,
        isReady: isReady,
        observableVideoPlayerController: ovpController,
        videoPlayerController: ovpController.videoPlayerController,
        inBuffering: inBuffering,
        isPlaying: isPlaying,
        videoDurationString: videoDurationString,
        videoDuration: videoDuration,
        videoPositionString: videoPositionString,
        videoPosition: videoPosition,
        displayControls: displayControls,
        isScrolling: isScrolling,
        videoSize: videoSize,
        volume: volume,
        showControls: showControls,
        startToggleControlsTimer: startToggleControlsTimer,
        startScrolling: startScrolling,
        stopScrolling: stopScrolling,
      ),
    );
  }
}
