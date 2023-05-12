// VideoPlayerArea stateful widget
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/video.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import 'controls_overlay.dart';
import 'dot_line_animation.dart';

final logger = Logger();

class VideoLoading extends StatelessWidget {
  final String coverHorizontal;
  const VideoLoading({Key? key, required this.coverHorizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                const Color.fromARGB(255, 0, 34, 79),
              ],
              stops: const [0.8, 1.0],
            ),
          ),
          child: SidImage(
            key: ValueKey(coverHorizontal ?? ''),
            sid: coverHorizontal ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Image(
            image: AssetImage('assets/images/logo.png'),
            width: 60.0,
          ),
          DotLineAnimation(),
          SizedBox(height: 15),
          Text(
            '精彩即將呈現',
            style: TextStyle(fontSize: 12, color: Colors.white),
          )
        ]),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}

class VideoError extends StatelessWidget {
  final String coverHorizontal;
  final onTap;

  const VideoError({
    Key? key,
    required this.coverHorizontal,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                const Color.fromARGB(255, 0, 34, 79),
              ],
              stops: const [0.8, 1.0],
            ),
          ),
          child: SidImage(
            key: ValueKey(coverHorizontal),
            sid: coverHorizontal,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onTap,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 45.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}

class VideoPlayerArea extends StatefulWidget {
  final int id;
  final String? name;
  final String videoUrl;
  final Video video;
  final VideoPlayerController? controller;

  VideoPlayerArea({
    Key? key,
    required this.id,
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
  VideoPlayerController? _controller;
  final VodApi vodApi = VodApi();
  bool isFullscreen = false;
  bool hasError = false;
  bool isScreenLocked = false;
  Orientation orientation = Orientation.portrait;

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

  void _onControllerValueChanged() async {
    if (!mounted) {
      return;
    }

    if (_controller!.value.hasError) {
      setState(() {
        hasError = true;
      });
    }
    if (_controller!.value.isBuffering) {
      print('👹👹👹 isBuffering');
    } else {
      // 當視頻停止緩衝並準備播放時，自動播放視頻
      print('==================================');
      print('_controller!.value: ${_controller!.value}');
      print('_controller!.value.isPlaying: ${_controller!.value.isPlaying}');
      print('hasError: $hasError');
      print('==================================');

      // if (_controller!.value.isPlaying == false &&
      //     !_controller!.value.hasError) {
      //   _controller!.play();
      // }
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        _controller?.pause(); // Pause the video
        toggleFullscreen(fullScreen: false);
        break;
      case AppLifecycleState.resumed:
        _controller?.play(); // Resume the video
        break;
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final _orientation =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).orientation;
    // print("@@@@@@@@@ didChangeMetrics: $_orientation");
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
    WidgetsBinding.instance.removeObserver(this);
    _controller?.pause();
    _controller!.removeListener(_onControllerValueChanged);
    _controller?.dispose();
    // setScreenPortrait();
    logger.i('👹👹👹 LEAVE VIDEO PAGE!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double playerHeight = isFullscreen
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width / 16 * 9;

    var aspectRatio = _controller!.value.size.width == 0 ||
            _controller!.value.size.height == 0
        ? 16 / 9
        : _controller!.value.size.width / _controller!.value.size.height;

    var currentRoutePath = MyRouteDelegate.of(context).currentConfiguration;
    if (currentRoutePath != '/video') {
      _controller?.pause();
      setScreenPortrait();
    }

    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: playerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (hasError) ...[
            VideoError(
              coverHorizontal: widget.video.coverHorizontal ?? '',
              onTap: () {
                setState(() {
                  hasError = false;
                });
                initializePlayer();
              },
            ),
          ] else if (_controller != null &&
              _controller!.value.isInitialized) ...[
            AspectRatio(
              aspectRatio: aspectRatio,
              child: VideoPlayer(_controller!),
            ),
            ControlsOverlay(
              controller: _controller!,
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
      ),
    );
  }
}
