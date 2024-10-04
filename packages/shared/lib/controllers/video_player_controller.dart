import 'dart:async';
// import 'dart:html' if (dart.library.html) 'dart:html' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../utils/screen_control.dart';

bool isFirstTimeForIOSSafari = true;

final logger = Logger();

class ObservableVideoPlayerController extends GetxController {
  final isReady = false.obs;
  bool autoPlay; //
  // final RxString videoAction = kIsWeb ? 'pause'.obs : 'play'.obs;
  final RxString videoAction = 'pause'.obs;
  late VideoPlayerController? videoPlayerController;
  final RxBool isVisibleControls = false.obs;
  final String videoUrl;
  final String tag;
  final RxBool isFullscreen = false.obs;
  var isMuted = kIsWeb ? true.obs : false.obs;
  bool shouldMuteByDefault = true;

  var errorMessage = ''.obs;

  ObservableVideoPlayerController(
    this.tag,
    this.videoUrl,
    this.autoPlay,
    this.shouldMuteByDefault,
  );

  @override
  void onInit() {
    if (!kIsWeb) {
      FlutterVolumeController.addListener(
        (volume) {
          logger.i('volume: $volume');
          if (volume == 0) {
            isMuted.value = true;
          } else {
            isMuted.value = false;
          }
          videoPlayerController?.setVolume(volume);
        },
      );
    }

    // _checkHlsJs();
    _initializePlayer();

    super.onInit();
  }

  @override
  void dispose() {
    _disposePlayer();
    // FlutterVolumeController.removeListener();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      await _setupVideoPlayerController();
      await _initializeController();
      await _configureMuteStatus();
      _handleAutoPlay();
    } catch (error) {
      _handleInitializationError();
    }
  }

  Future<void> _setupVideoPlayerController() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    videoPlayerController?.addListener(_onControllerValueChanged);
  }

  Future<void> _initializeController() async {
    await videoPlayerController?.initialize();
    isReady.value = true;
  }

  Future<void> _configureMuteStatus() async {
    bool muteValue = kIsWeb
        ? shouldMuteByDefault || (isMuted.value && shouldMuteByDefault)
        : await FlutterVolumeController.getMute() ?? false;
    isMuted.value = muteValue;
    await videoPlayerController?.setVolume(muteValue ? 0.0 : 1.0);
  }

  void _handleAutoPlay() {
    if (autoPlay) {
      play();
    }
  }

  void _handleInitializationError() {
    if (videoPlayerController?.value.hasError == true) {
      videoAction.value = 'error';
      errorMessage.value = videoPlayerController!.value.errorDescription!;
    }
  }

  void _disposePlayer() {
    videoPlayerController?.pause();
    videoPlayerController?.removeListener(_onControllerValueChanged);
    videoPlayerController?.dispose();
    videoPlayerController = null;
  }

  void _onControllerValueChanged() {
    if (videoPlayerController?.value.hasError == true) {
      videoAction.value = 'error';
      errorMessage.value = videoPlayerController!.value.errorDescription!;
    }

    if (videoPlayerController?.value.isPlaying == true &&
        videoAction.value == 'pause') {
      videoAction.value = 'play';
    }

    // TODO: 有待分析
    if (!kIsWeb && videoPlayerController?.value.isPlaying == true) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  void play() {
    videoAction.value = 'play';
    videoPlayerController?.play();
  }

  void replay() {
    videoAction.value = 'play';
    videoPlayerController?.seekTo(Duration.zero);
    videoPlayerController?.play();
  }

  void pause() {
    videoAction.value = 'pause';
    videoPlayerController?.pause();
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

  // toggleMute
  void toggleMute() async {
    if (!kIsWeb) {
      final currentVolume = await FlutterVolumeController.getVolume();
      if (currentVolume == 0) {
        await FlutterVolumeController.setVolume(0.2);
        isMuted.value = false;
      } else {
        await FlutterVolumeController.setMute(true);
        isMuted.value = true;
      }
      update();
    } else {
      videoPlayerController?.setVolume(isMuted.value ? 1 : 0);
      isMuted.value = !isMuted.value;
    }
  }
}
