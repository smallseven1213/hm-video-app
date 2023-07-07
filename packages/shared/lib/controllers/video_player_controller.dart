import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../utils/screen_control.dart';

final logger = Logger();

bool isFirstTimeForIOSSafari = true;

class ObservableVideoPlayerController extends GetxController {
  final isReady = false.obs;
  // final RxString videoAction = kIsWeb ? 'pause'.obs : 'play'.obs;
  final RxString videoAction = 'pause'.obs;
  late VideoPlayerController videoPlayerController;
  final RxBool isVisibleControls = false.obs;
  final String videoUrl;
  final String obsKey;
  final RxBool isFullscreen = false.obs;

  var errorMessage = ''.obs;

  ObservableVideoPlayerController(this.obsKey, this.videoUrl);

  @override
  void onInit() {
    _initializePlayer();

    super.onInit();
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(videoUrl);
    videoPlayerController.addListener(_onControllerValueChanged);
    videoPlayerController.initialize().then((value) {
      logger.i('VPC safari trace : initialize');
      isReady.value = true;
    }).catchError((error) {
      logger.i('VPC safari trace : Error: $error');
      if (videoPlayerController.value.hasError) {
        videoAction.value = 'error';
        errorMessage.value = videoPlayerController.value.errorDescription!;
      }
    });
  }

  void changeVolumeToFull() {
    videoPlayerController.setVolume(1);
  }

  void _disposePlayer() {
    videoPlayerController.pause();
    videoPlayerController.removeListener(_onControllerValueChanged);
    videoPlayerController.dispose();
  }

  void _onControllerValueChanged() {
    if (videoPlayerController.value.hasError) {
      videoAction.value = 'error';
      errorMessage.value = videoPlayerController.value.errorDescription!;
    }

    if (videoPlayerController.value.isPlaying && videoAction.value == 'pause') {
      videoAction.value = 'play';
    }

    // TODO: 有待分析
    if (!kIsWeb && videoPlayerController.value.isPlaying) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
  }

  void play() {
    logger.i('RENDER OBX: PLAY VIDEO PLAYER CTRL id: $videoUrl');
    videoAction.value = 'play';
    videoPlayerController.play();
  }

  void replay() {
    logger.i('RENDER OBX: REPLAY VIDEO PLAYER CTRL id: $videoUrl');
    videoAction.value = 'play';
    videoPlayerController.seekTo(Duration.zero);
    videoPlayerController.play();
  }

  void pause() {
    logger.i('RENDER OBX: PAUSE VIDEO PLAYER CTRL id: $videoUrl');
    videoAction.value = 'pause';
    videoPlayerController.pause();
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

  void toggleFullScreen() {
    isFullscreen.value = !isFullscreen.value;
    if (isFullscreen.value) {
      setScreenLandScape();
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    update();
  }
}
