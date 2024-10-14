import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:shared/widgets/posts/video/controls_overlay/index.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/models/post.dart';

import 'error.dart';
import 'loading.dart';

final logger = Logger();

class VideoPlayerWidget extends StatefulWidget {
  final String? name;
  final String videoUrl;
  final Vod video;
  final String tag;
  final Function showConfirmDialog;
  final Function? togglePopup;

  final bool? displayHeader;
  final bool? displayFullscreenIcon;
  final bool? hasPaymentProcess;
  final Color? themeColor;
  final Widget? buildLoadingWidget;
  final bool? useGameDeposit;
  final ObservableVideoPlayerController? controller;
  final Files? file;
  final Widget? loadingAnimation;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.video,
    required this.tag,
    required this.showConfirmDialog,
    this.togglePopup,
    this.displayHeader = true,
    this.displayFullscreenIcon = true,
    this.hasPaymentProcess = true,
    this.name,
    this.themeColor = Colors.blue,
    this.buildLoadingWidget,
    this.useGameDeposit = false,
    this.controller,
    this.file,
    this.loadingAnimation,
  }) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver, RouteAware {
  final VodApi vodApi = VodApi();
  bool isFullscreen = false;
  bool hasError = false;
  bool isScreenLocked = false;
  Orientation orientation = Orientation.portrait;
  bool isFirstLookForWeb = true; // 給web feature專用，如果是web都要檢查此值做些事情

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setScreenRotation();
  }

  void toggleFullscreen({bool fullScreen = false}) {
    if (widget.togglePopup != null) {
      widget.togglePopup!();
    } else {
      setState(() {
        isFullscreen = fullScreen;
        isScreenLocked = isFullscreen;
      });
    }
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
    return Container(
      color: Colors.black,
      child: VideoPlayerConsumer(
        tag: widget.tag,
        child: (videoPlayerInfo) {
          Size videoSize = videoPlayerInfo.videoPlayerController!.value.size;
          var aspectRatio = videoSize.width == 0 || videoSize.height == 0
              ? 16 / 9
              : videoSize.width / videoSize.height;

          double playerWidth = MediaQuery.of(context).size.width;
          double playerHeight = isFullscreen
              ? MediaQuery.of(context).size.height
              : playerWidth / aspectRatio;

          final coverHorizontal = widget.file?.cover ?? '';
          if (videoPlayerInfo.videoAction == 'error') {
            return SizedBox(
              height: playerHeight,
              child: VideoError(
                coverHorizontal: coverHorizontal,
                onTap: () {
                  videoPlayerInfo.videoPlayerController?.play();
                },
              ),
            );
          }

          if (videoPlayerInfo.videoPlayerController?.value.isInitialized ==
              false) {
            return widget.buildLoadingWidget ??
                SizedBox(
                  height: playerHeight,
                  child: VideoLoading(
                    coverHorizontal: coverHorizontal,
                  ),
                );
          }

          if (videoPlayerInfo.inBuffering) {
            return SizedBox(
                height: playerHeight,
                child: Center(
                  child: widget.loadingAnimation ??
                      const CircularProgressIndicator(),
                ));
          }

          return SizedBox(
            height: playerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (widget.controller != null &&
                    !widget.controller!.autoPlay &&
                    widget.controller!.videoAction.value != 'play' &&
                    widget.controller!.initCover.value &&
                    widget.controller!.videoPlayerController?.value.position
                            .inSeconds ==
                        0) ...[
                  AspectRatio(
                    aspectRatio: aspectRatio,
                    child: SidImage(
                      key: ValueKey(coverHorizontal),
                      sid: coverHorizontal,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ] else ...[
                  AspectRatio(
                    aspectRatio: aspectRatio,
                    child: VideoPlayer(videoPlayerInfo.videoPlayerController!),
                  ),
                ],
                ControlsOverlay(
                  tag: widget.tag,
                  name: widget.video.title,
                  isFullscreen: isFullscreen,
                  displayHeader: widget.displayHeader,
                  displayFullScreenIcon: widget.displayFullscreenIcon,
                  themeColor: widget.themeColor ?? Colors.blue,
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
                  isScreenLocked: isScreenLocked,
                  toggleFullscreen: (status) {
                    toggleFullscreen(fullScreen: status);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
