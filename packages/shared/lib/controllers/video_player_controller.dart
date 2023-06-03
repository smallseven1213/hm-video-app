import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

final logger = Logger();

bool isFirstTimeForIOSSafari = true;

class ObservableVideoPlayerController extends GetxController {
  final isReady = false.obs;
  // final RxString videoAction = kIsWeb ? 'pause'.obs : 'play'.obs;
  final RxString videoAction = 'pause'.obs;
  VideoPlayerController? videoPlayerController;
  final RxBool isVisibleControls = false.obs;
  final String videoUrl;
  late Future<void> initialization;

  ObservableVideoPlayerController(this.videoUrl);

  @override
  void onInit() {
    initialization = _initializePlayer();

    super.onInit();
  }

  // @override
  // void onClose() {
  //   logger.i('VPC LISTEN: CTX Life CLOSE VIDEO PLAYER CTRL id: $videoUrl');
  //   _disposePlayer();
  //   super.onClose();
  // }

  Future<void> _initializePlayer() async {
    logger.i('VPC LISTEN: INIT VIDEO PLAYER CTRL id: $videoUrl');
    try {
      _disposePlayer();
      videoPlayerController = VideoPlayerController.network(videoUrl);
      videoPlayerController!.addListener(_onControllerValueChanged);
      await videoPlayerController!.initialize();
      // videoPlayerController!.pause();
      videoPlayerController!.setLooping(true);
      isReady.value = true;
    } catch (error) {
      logger.e('👹👹👹 Error occurred: $error');
      if (videoPlayerController!.value.hasError) {
        videoAction.value = 'error';
      }
    }
  }

  void _disposePlayer() {
    if (videoPlayerController != null) {
      videoPlayerController?.removeListener(_onControllerValueChanged);
      videoPlayerController?.dispose();
      videoPlayerController = null;
    }
  }

  void _onControllerValueChanged() {
    if (videoPlayerController!.value.hasError) {
      logger.i(
          'VPC LISTEN: error ${videoPlayerController!.value.errorDescription}');
      videoAction.value = 'error';
    }

    if (!kIsWeb && videoPlayerController!.value.isPlaying) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
  }

  void play() {
    logger.i('RENDER OBX: PLAY VIDEO PLAYER CTRL id: $videoUrl');
    videoAction.value = 'play';
    videoPlayerController?.play();
  }

  void replay() {
    logger.i('RENDER OBX: REPLAY VIDEO PLAYER CTRL id: $videoUrl');
    videoAction.value = 'play';
    videoPlayerController?.seekTo(Duration.zero);
    videoPlayerController?.play();
  }

  void pause() {
    logger.i('RENDER OBX: PAUSE VIDEO PLAYER CTRL id: $videoUrl');
    videoAction.value = 'pause';
    videoPlayerController?.pause();
  }

  void toggle() {
    logger
        .i('RENDER OBX: TOGGLE VIDEO PLAYER CTRL toggle: ${videoAction.value}');
    if (videoAction.value == 'play') {
      pause();
    } else {
      play();
    }
  }

  void toggleControls() {
    isVisibleControls.value = !isVisibleControls.value;
    update();
  }
}
