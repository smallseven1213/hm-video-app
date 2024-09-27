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
  final bool? isShort;
  final RxBool isFullscreen = false.obs;
  var isMuted = kIsWeb ? true.obs : false.obs;
  // var isMuted = false.obs;

  var errorMessage = ''.obs;

  ObservableVideoPlayerController(
      this.tag, this.videoUrl, this.autoPlay, this.isShort);

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
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    videoPlayerController?.addListener(_onControllerValueChanged);
    videoPlayerController?.initialize().then((value) async {
      isReady.value = true;
      final muteValue = kIsWeb
          ? (kIsWeb && isShort! ? !isMuted.value : isMuted.value)
          : await FlutterVolumeController.getMute();
      if (kIsWeb && isShort!) {
        isMuted.value = !isMuted.value;
      }

      final volume = muteValue == true ? 0.0 : 1.0;

      videoPlayerController?.setVolume(volume);

      if (autoPlay) {
        play();
      }
    }).catchError((error) {
      if (videoPlayerController?.value.hasError == true) {
        videoAction.value = 'error';
        errorMessage.value = videoPlayerController!.value.errorDescription!;
      }
    });
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
