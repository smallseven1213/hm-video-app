import 'package:flutter/foundation.dart';
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

  ObservableVideoPlayerController(this.videoUrl);

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    logger.i('RENDER OBX: INIT VIDEO PLAYER CTRL id: $videoUrl');
    try {
      videoPlayerController =
          VideoPlayerController.network(videoUrl); // 使用成员变量 videoUrl
      // videoPlayerController!.addListener(_onControllerValueChanged);
      await videoPlayerController!.initialize();
      videoPlayerController!.setLooping(true);
      isReady.value = true;
      videoAction.value = 'play';

      play();
    } catch (error) {
      print('👹👹👹 Error occurred: $error');
      if (videoPlayerController!.value.hasError) {
        hasError.value = true;
      }
    }
  }

  void _onControllerValueChanged() {
    if (videoPlayerController!.value.hasError) {
      hasError.value = true;
      initializePlayer();
      print(
          '👹👹👹 Error occurred: ${videoPlayerController!.value.errorDescription}');
    }

    if (videoPlayerController!.value.isBuffering == false) {
      if (videoPlayerController!.value.position ==
          videoPlayerController!.value.duration) {
        pause();
      } else if (videoPlayerController!.value.isPlaying == false &&
          !hasError.value &&
          isPause.value == false) {
        play();
      }
    }

    if (!kIsWeb && videoPlayerController!.value.isPlaying) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
  }

  @override
  void onClose() {
    videoPlayerController!.removeListener(_onControllerValueChanged);
    videoPlayerController?.dispose();
    super.onClose();
  }

  void setVideoPlayerController(VideoPlayerController controller) {
    videoPlayerController = controller;
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
