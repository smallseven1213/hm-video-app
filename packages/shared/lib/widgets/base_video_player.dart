import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/video.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

final logger = Logger();

abstract class BaseVideoPlayerWidget extends StatefulWidget {
  final Video video;
  final String videoUrl;

  const BaseVideoPlayerWidget({
    Key? key,
    required this.video,
    required this.videoUrl,
  });

  @override
  BaseVideoPlayerWidgetState createState();
}

abstract class BaseVideoPlayerWidgetState extends State<BaseVideoPlayerWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  final VodApi vodApi = VodApi();
  bool isFullscreen = false;
  bool hasError = false;
  bool isScreenLocked = false;
  Orientation orientation = Orientation.portrait;
  bool isPause = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializePlayer();
    setScreenRotation();
  }

  initializePlayer() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl);
      // 監聽播放狀態
      _controller!.addListener(_onControllerValueChanged);
      _controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _controller!.play();
        });
      }).catchError((_) => initializePlayer());
    } catch (error) {
      print('👹👹👹 Error occurred: $error');
      if (_controller!.value.hasError) {
        setState(() {
          hasError = true;
        });
      }
    }
  }

  void _onControllerValueChanged() async {
    if (!mounted) {
      return;
    }

    if (_controller!.value.hasError) {
      setState(() {
        hasError = true;
      });
      initializePlayer();
      print('👹👹👹 Error occurred: ${_controller!.value.errorDescription}');
    }

    if (_controller!.value.isBuffering == false) {
      // 如果影片播放完畢，則暫停
      if (_controller!.value.position == _controller!.value.duration) {
        _controller!.pause();
      } else if (_controller!.value.isPlaying == false &&
          !hasError &&
          isPause == false) {
        _controller!.play();
      }
    }

    if (!kIsWeb && _controller!.value.isPlaying) {
      // 保持屏幕亮度
      // var isLock = await Wakelock.enabled;
      // if (!isLock) {
      //   Wakelock.enable();
      // }
      Wakelock.enable();
    } else {
      // 恢復正常屏幕行為
      Wakelock.disable();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller!.removeListener(_onControllerValueChanged);
    _controller?.dispose();
    logger.i('👹👹👹 LEAVE VIDEO PAGE!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentRoutePath = MyRouteDelegate.of(context).currentConfiguration;
    if (currentRoutePath != '/video' ||
        currentRoutePath != '/shorts_by_block') {
      _controller?.pause();
      setScreenPortrait();
    }

    return buildPage(context, controller: _controller);
  }

  Widget buildPage(BuildContext context, {VideoPlayerController? controller});
}
