import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:shared/widgets/video/purchase_promotion.dart';
import 'package:video_player/video_player.dart';

import '../../../widgets/purchase_promotion/coin_part.dart';
import '../../../widgets/purchase_promotion/vip_part.dart';
import 'controls_overlay.dart';
import 'error.dart';
import 'loading.dart';

final logger = Logger();

class VideoPlayerArea extends StatefulWidget {
  final String? name;
  final String videoUrl;
  final Vod video;
  final String tag;

  const VideoPlayerArea({
    Key? key,
    required this.videoUrl,
    required this.video,
    this.name,
    required this.tag,
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
  bool isFirstLookForWeb = true; // 给web feature专用，如果是web都要检查此值做些事情

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    setScreenRotation();
  }

  void toggleFullscreen({bool fullScreen = false}) {
    if (fullScreen) {
      setScreenLandScape();
    } else {
      setScreenPortrait();
      // 五秒后侦测萤幕方向
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
      // 隐藏状态栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      // 显示状态栏
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
        ? MediaQuery.sizeOf(context).height
        : MediaQuery.sizeOf(context).width / 16 * 9;

    return Container(
      color: Colors.black,
      width: MediaQuery.sizeOf(context).width,
      height: playerHeight,
      child: VideoPlayerConsumer(
        tag: widget.videoUrl,
        child: (videoPlayerInfo) {
          Size videoSize = videoPlayerInfo.videoPlayerController!.value.size;
          var aspectRatio = videoSize.width == 0 || videoSize.height == 0
              ? 16 / 9
              : videoSize.width / videoSize.height;
          final coverHorizontal = widget.video.coverHorizontal ?? '';

          if (videoPlayerInfo.videoAction == 'error') {
            return VideoError(
              coverHorizontal: coverHorizontal,
              onTap: () {
                videoPlayerInfo.videoPlayerController?.play();
              },
            );
          }

          if (videoPlayerInfo.videoPlayerController?.value.isInitialized ==
              false) {
            return VideoLoading(coverHorizontal: coverHorizontal);
          }
          if (widget.video.isAvailable == false &&
              videoPlayerInfo.videoAction == 'end') {
            return PurchasePromotion(
              coverHorizontal: coverHorizontal,
              buyPoints: widget.video.buyPoint.toString(),
              timeLength: widget.video.timeLength ?? 0,
              chargeType: widget.video.chargeType ?? 0,
              videoId: widget.video.id,
              videoPlayerInfo: videoPlayerInfo,
              title: widget.video.title,
              tag: widget.tag,
              vipPartBuilder: (timeLength) => VipPart(timeLength: timeLength),
              coinPartBuilder: ({
                required String buyPoints,
                required int videoId,
                required VideoPlayerInfo videoPlayerInfo,
                required int timeLength,
                required Function() onSuccess,
                userPoints,
              }) =>
                  CoinPart(
                buyPoints: buyPoints,
                videoId: videoId,
                videoPlayerInfo: videoPlayerInfo,
                timeLength: timeLength,
              ),
            );
          }

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: aspectRatio,
                child: VideoPlayer(videoPlayerInfo.videoPlayerController!),
              ),
              ControlsOverlay(
                videoUrl: widget.videoUrl,
                name: widget.video.title,
                isFullscreen: isFullscreen,
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
          );
        },
      ),
    );
  }
}
