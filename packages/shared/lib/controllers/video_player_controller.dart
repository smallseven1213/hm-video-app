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
  // final isPageActive = true.obs;
  final isReady = false.obs;
  final RxString videoAction = kIsWeb ? 'pause'.obs : 'play'.obs;
  VideoPlayerController? videoPlayerController;
  final RxBool isVisibleControls = false.obs;
  final String videoUrl;
  final RxBool isDisposed = false.obs;

  ObservableVideoPlayerController(this.videoUrl);

  @override
  void onInit() {
    // logger.i('VPC LISTEN: CTX Life INIT VIDEO PLAYER CTRL id: $videoUrl');
    _initializePlayer();

    // isPageActive.listen((value) {
    //   logger.i('VPC LISTEN: CTX Life INIT VIDEO PLAYER CTRL id: $videoUrl');
    //   if (value && videoAction.value == 'pause') {
    //     play();
    //   }
    // });
    super.onInit();
  }

  @override
  void dispose() {
    logger.i('VPC LISTEN: CTX Life DISPOSE VIDEO PLAYER CTRL id: $videoUrl');
    _disposePlayer();
    Get.delete<ObservableVideoPlayerController>(tag: videoUrl);
    super.dispose();
  }

  @override
  void onClose() {
    logger.i('VPC LISTEN: CTX Life CLOSE VIDEO PLAYER CTRL id: $videoUrl');
    super.onClose();
  }

  // void setIsPageActive(bool value) {
  //   isPageActive.value = value;
  // }

  Future<void> _initializePlayer() async {
    logger.i('VPC LISTEN: INIT VIDEO PLAYER CTRL id: $videoUrl');
    try {
      _disposePlayer();
      videoPlayerController = VideoPlayerController.network(videoUrl);
      videoPlayerController!.addListener(_onControllerValueChanged);
      await videoPlayerController!.initialize();
      videoPlayerController!.setLooping(true);
      isReady.value = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // if (kIsWeb && isFirstTimeForIOSSafari) {
        //   videoPlayerController!.setVolume(0);
        // }

        if (kIsWeb) {
          videoPlayerController!.setVolume(0);
          play();
          // Timer(const Duration(milliseconds: 500), () {
          //   play();
          // });
        } else {
          play();
        }
      });
    } catch (error) {
      logger.e('👹👹👹 Error occurred: $error');
      if (videoPlayerController!.value.hasError) {
        videoAction.value = 'error';
      }
    }
  }

  void userDidClick() {
    // 使用者點擊後，將音量設為正常，並設定 isFirstTimeForIOSSafari 為 false
    if (isFirstTimeForIOSSafari) {
      logger.i('VPC LISTEN: userDidClick');
      videoPlayerController?.setVolume(1.0);
      isFirstTimeForIOSSafari = false;
    }
  }

  void _disposePlayer() {
    if (videoPlayerController != null) {
      videoPlayerController!.removeListener(_onControllerValueChanged);
      videoPlayerController!.dispose();
      videoPlayerController = null;
    }
  }

  void _onControllerValueChanged() {
    if (videoPlayerController!.value.hasError) {
      logger.i(
          'VPC LISTEN: error ${videoPlayerController!.value.errorDescription}');
      videoAction.value = 'error';
      pause();
      // _initializePlayer();
    }

    // if (videoPlayerController!.value.isBuffering == false) {
    //   if (videoPlayerController!.value.position ==
    //       videoPlayerController!.value.duration) {
    //     pause();
    //   } else if (videoPlayerController!.value.isPlaying == false &&
    //       !hasError.value &&
    //       isPause.value == false) {
    //     play();
    //   }
    // }

    if (!kIsWeb && videoPlayerController!.value.isPlaying) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
  }

  void setVideoPlayerController(VideoPlayerController controller) {
    videoPlayerController = controller;
  }

  void play() {
    if (isDisposed.value) {
      return;
    }
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

  void setControls(bool value) {
    userDidClick();
    isVisibleControls.value = value;
    update();
  }
}
