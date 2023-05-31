// VideoPlayerArea stateful widget
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/video.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import 'controls_overlay.dart';
import 'error.dart';
import 'loading.dart';

final logger = Logger();

class VideoPlayerArea extends StatefulWidget {
  final String? name;
  final String videoUrl;
  final Video video;
  final VideoPlayerController? controller;

  VideoPlayerArea({
    Key? key,
    required this.videoUrl,
    required this.video,
    this.name,
    this.controller,
  }) : super(key: key);

  @override
  _VideoPlayerAreaState createState() => _VideoPlayerAreaState();
}

class _VideoPlayerAreaState extends State<VideoPlayerArea>
    with WidgetsBindingObserver {
  final VodApi vodApi = VodApi();
  bool isFullscreen = false;
  bool hasError = false;
  bool isScreenLocked = false;
  Orientation orientation = Orientation.portrait;
  ObservableVideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // initializePlayer();
    setScreenRotation();
    _putController();
  }

  void _putController() async {
    var videoUrl = widget.videoUrl;

    // videoPlayerController =
    //     Get.put(ObservableVideoPlayerController(videoUrl), tag: videoUrl);

    await Get.putAsync<ObservableVideoPlayerController>(() async {
      videoPlayerController = ObservableVideoPlayerController(videoUrl);
      logger.i('RENDER OBX: ShortCard didChangeDependencies retry');
      return videoPlayerController!;
    }, tag: videoUrl);
    setState(() {
      videoPlayerController!.play();
    });
  }

  void toggleFullscreen({bool fullScreen = false}) {
    if (fullScreen) {
      setScreenLandScape();
    } else {
      setScreenPortrait();
      // 五秒後偵測螢幕方向
      Future.delayed(const Duration(seconds: 2), () {
        setScreenRotation();
      });
    }

    setState(() {
      isFullscreen = fullScreen;
      isScreenLocked = isFullscreen;
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final _orientation =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).orientation;
    // logger.i("@@@@@@@@@ didChangeMetrics: $_orientation");
    if (_orientation == Orientation.landscape) {
      // 隱藏狀態欄
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      // 顯示狀態欄
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        SystemUiOverlay.bottom,
        SystemUiOverlay.top,
      ]);
    }
    // if (isScreenLocked == true) return;
    setState(() {
      isFullscreen = _orientation == Orientation.landscape;
      orientation = _orientation;
    });
  }

  @override
  void dispose() {
    setScreenPortrait();
    WidgetsBinding.instance.removeObserver(this);
    videoPlayerController!.dispose();
    logger.i('👹👹👹 LEAVE VIDEO PAGE!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isObsVideoPlayerControllerReady =
        Get.isRegistered<ObservableVideoPlayerController>(tag: widget.videoUrl);

    double playerHeight = isFullscreen
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width / 16 * 9;

    logger.i(
        'RENDER OBX: isObsVideoPlayefffrControllerReady id: ${isObsVideoPlayerControllerReady}');

    if (isObsVideoPlayerControllerReady) {
      final obsVideoPlayerController =
          Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);

      return Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: playerHeight,
        child: Obx(() {
          var aspectRatio = obsVideoPlayerController
                          .videoPlayerController!.value.size.width ==
                      0 ||
                  obsVideoPlayerController
                          .videoPlayerController!.value.size.height ==
                      0
              ? 16 / 9
              : obsVideoPlayerController
                      .videoPlayerController!.value.size.width /
                  obsVideoPlayerController
                      .videoPlayerController!.value.size.height;

          var currentRoutePath =
              MyRouteDelegate.of(context).currentConfiguration;
          if (currentRoutePath != '/video') {
            obsVideoPlayerController.videoPlayerController?.pause();
            setScreenPortrait();
          }
          logger.i(
              '====? obsVideoPlayerController.isReadyL ${obsVideoPlayerController.isReady.value}');
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (obsVideoPlayerController.videoAction.value == 'error') ...[
                VideoError(
                  coverHorizontal: widget.video.coverHorizontal ?? '',
                  onTap: () {
                    // setState(() {
                    //   hasError = false;
                    // });
                    // obsVideoPlayerController._initializePlayer()  ;
                  },
                ),
              ] else if (obsVideoPlayerController.isReady.value) ...[
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(
                      obsVideoPlayerController.videoPlayerController!),
                ),
                ControlsOverlay(
                  controller: obsVideoPlayerController.videoPlayerController!,
                  name: widget.video.title,
                  isFullscreen: isFullscreen,
                  toggleFullscreen: (status) {
                    toggleFullscreen(fullScreen: status);
                  },
                  isScreenLocked: isScreenLocked,
                  onScreenLock: (bool isLocked) {
                    setState(() {
                      isScreenLocked = isLocked;
                    });
                    if (isLocked) {
                      toggleFullscreen(fullScreen: true);
                    } else {
                      setScreenRotation();
                    }
                  },
                ),
              ] else ...[
                VideoLoading(
                  coverHorizontal: widget.video.coverHorizontal ?? '',
                )
              ],
            ],
          );
        }),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
