// VideoPlayerArea stateful widget
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:video_player/video_player.dart';

import 'controls_overlay.dart';
import 'error.dart';
import 'loading.dart';

final logger = Logger();

class VideoPlayerArea extends StatefulWidget {
  final String? name;
  final String videoUrl;
  final Vod video;
  final VideoPlayerController? controller;

  const VideoPlayerArea({
    Key? key,
    required this.videoUrl,
    required this.video,
    this.name,
    this.controller,
  }) : super(key: key);

  @override
  VideoPlayerAreaState createState() => VideoPlayerAreaState();
}

class VideoPlayerAreaState extends State<VideoPlayerArea>
    with WidgetsBindingObserver, RouteAware {
  final VodApi vodApi = VodApi();
  bool isFullscreen = false;
  bool hasError = false;
  bool isScreenLocked = false;
  Orientation orientation = Orientation.portrait;
  late ObservableVideoPlayerController videoPlayerController;
  bool isFirstLookForWeb = true; // 給web feature專用，如果是web都要檢查此值做些事情

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    setScreenRotation();
    var videoUrl = widget.videoUrl;

    videoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: videoUrl);

    videoPlayerController.isReady.listen((isReady) {
      if (isReady) {
        logger.i('VPC safari trace : isReady');
        setState(() {});
        if (!kIsWeb) {
          videoPlayerController.play();
        }
      }
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
    // ignore: no_leading_underscores_for_local_identifiers
    final _orientation =
        // ignore: deprecated_member_use
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double playerHeight = isFullscreen
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width / 16 * 9;

    logger.i('VPC safari trace : obs testing ');

    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: playerHeight,
      child: Obx(() {
        Size videoSize = videoPlayerController.videoPlayerController.value.size;
        var aspectRatio = videoSize.width == 0 || videoSize.height == 0
            ? 16 / 9
            : videoSize.width / videoSize.height;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (videoPlayerController.videoAction.value == 'error') ...[
              VideoError(
                coverHorizontal: widget.video.coverHorizontal ?? '',
                onTap: () {
                  // setState(() {
                  //   hasError = false;
                  // });
                  videoPlayerController.play();
                },
              ),
            ] else if (videoPlayerController
                .videoPlayerController.value.isInitialized) ...[
              AspectRatio(
                aspectRatio: aspectRatio,
                child: VideoPlayer(videoPlayerController.videoPlayerController),
              ),
              ControlsOverlay(
                controller: videoPlayerController.videoPlayerController,
                name: widget.video.title,
                isFullscreen: isFullscreen,
                toggleFullscreen: (status) {
                  toggleFullscreen(fullScreen: status);
                },
                isScreenLocked: isScreenLocked,
                isPlaying: videoPlayerController.videoAction.value == 'play',
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
            ] else if (videoPlayerController
                    .videoPlayerController.value.isInitialized ==
                false) ...[
              VideoLoading(
                coverHorizontal: widget.video.coverHorizontal ?? '',
              )
            ],
            // if (kIsWeb &&
            //     isFirstLookForWeb &&
            //     videoPlayerController.videoPlayerController.value.isInitialized)
            //   InkWell(
            //     onTap: () {
            //       setState(() {
            //         isFirstLookForWeb = false;
            //         videoPlayerController.play();
            //       });
            //     },
            //     child: SizedBox(
            //       width: double.infinity,
            //       height: double.infinity,
            //       child: Center(
            //         child: Container(
            //           width: 100,
            //           height: 100,
            //           decoration: BoxDecoration(
            //               color: Colors.black.withOpacity(0.5),
            //               shape: BoxShape.circle),
            //           child: const Center(
            //             child: Icon(
            //               Icons.play_arrow,
            //               color: Colors.white,
            //               size: 45.0,
            //               semanticLabel: 'Play',
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   )
          ],
        );
      }),
    );
  }
}
