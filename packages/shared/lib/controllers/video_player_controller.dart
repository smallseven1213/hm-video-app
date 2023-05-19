import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

final logger = Logger();

class ObservableVideoPlayerController extends GetxController {
  final isReady = false.obs;
  RxString videoAction = ''.obs;
  VideoPlayerController? videoPlayerController;
  RxBool hasError = false.obs;
  RxBool isPause = false.obs;
  RxBool isVisibleControls = false.obs;
  String videoUrl;
  RxBool isDisposed = false.obs;

  ObservableVideoPlayerController(this.videoUrl);

  @override
  void onInit() {
    logger.i('VPC LISTEN: CTX Life INIT VIDEO PLAYER CTRL id: $videoUrl');
    initializePlayer();
    super.onInit();
  }

  @override
  void dispose() {
    logger.i('VPC LISTEN: CTX Life DISPOSE VIDEO PLAYER CTRL id: $videoUrl');
    if (videoPlayerController != null) {
      videoPlayerController!.removeListener(_onControllerValueChanged);
      videoPlayerController!.dispose();
    }
    Get.delete<ObservableVideoPlayerController>(tag: videoUrl);
    super.dispose();
  }

  @override
  void onClose() {
    // if (videoPlayerController != null) {
    //   videoPlayerController!.removeListener(_onControllerValueChanged);
    //   videoPlayerController!.dispose();
    // }
    logger.i('VPC LISTEN: CTX Life CLOSE VIDEO PLAYER CTRL id: $videoUrl');
    super.onClose();
  }

  Future<void> initializePlayer() async {
    logger.i('VPC LISTEN: INIT VIDEO PLAYER CTRL id: $videoUrl');
    try {
      videoPlayerController?.dispose();
      videoPlayerController =
          VideoPlayerController.network(videoUrl); // 使用成员变量 videoUrl
      videoPlayerController!.addListener(_onControllerValueChanged);
      await videoPlayerController!.initialize();
      videoPlayerController!.setLooping(true);
      isReady.value = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        videoAction.value = 'play';
        videoPlayerController!.setVolume(0);
        // Plays the video once the widget is build and loaded.
        // if k is web , delay 1s to play()
        if (kIsWeb) {
          Timer(const Duration(milliseconds: 200), () {
            play();
          });
        } else {
          play();
        }
      });
    } catch (error) {
      print('👹👹👹 Error occurred: $error');
      if (videoPlayerController!.value.hasError) {
        hasError.value = true;
      }
    }
  }

  void _onControllerValueChanged() {
    if (videoPlayerController!.value.hasError) {
      logger.i(
          'VPC LISTEN: error ${videoPlayerController!.value.errorDescription}');
      hasError.value = true;
      initializePlayer();
    }

    // logger.i('VPC LISTEN: ${videoPlayerController!.value.position}');
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
    logger.i('RENDER OBX: TOGGLE VIDEO PLAYER CTRL id: $videoUrl');
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
    isVisibleControls.value = value;
    update();
  }
}
