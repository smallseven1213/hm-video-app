import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../utils/screen_control.dart';

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
      isReady.value = true;
    }).catchError((error) {
      if (videoPlayerController.value.hasError) {
        videoAction.value = 'error';
        errorMessage.value = videoPlayerController.value.errorDescription!;
      }
    });
  }

  void changeVolumeToFull() {
    if (!kIsWeb) {
      videoPlayerController.setVolume(1);
    }
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
    videoAction.value = 'play';
    videoPlayerController.play();
  }

  void replay() {
    videoAction.value = 'play';
    videoPlayerController.seekTo(Duration.zero);
    videoPlayerController.play();
  }

  void pause() {
    videoAction.value = 'pause';
    videoPlayerController.pause();
  }

  void toggle() {
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
