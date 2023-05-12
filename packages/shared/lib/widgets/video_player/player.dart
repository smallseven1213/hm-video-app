// VideoPlayerWidget stateful widget
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/video.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import 'error.dart';
import 'loading.dart';
import 'progress.dart';

final logger = Logger();

class VideoPlayerWidget extends StatefulWidget {
  final String? name;
  final String videoUrl;
  final Video video;
  final VideoPlayerController? controller;
  final double? height;

  VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.video,
    this.name,
    this.controller,
    this.height,
  }) : super(key: key);

  @override
  _VideoPlayerAreaState createState() => _VideoPlayerAreaState();
}

class _VideoPlayerAreaState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  final VodApi vodApi = VodApi();
  bool isFullscreen = false;
  bool hasError = false;
  bool isScreenLocked = false;
  Orientation orientation = Orientation.portrait;
  bool isPause = false;
  bool isVisibleControls = false;

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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _controller?.pause();
    _controller!.removeListener(_onControllerValueChanged);
    _controller?.dispose();
    // setScreenPortrait();
    logger.i('👹👹👹 LEAVE VIDEO PAGE!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentRoutePath = MyRouteDelegate.of(context).currentConfiguration;
    if (currentRoutePath != '/video') {
      _controller?.pause();
      setScreenPortrait();
    }
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (hasError) ...[
            VideoError(
              coverHorizontal: widget.video.coverHorizontal ?? '',
              onTap: () {
                print('👹👹👹 onTap');
                _controller?.play();
                setState(() {
                  hasError = false;
                });
              },
            ),
            Stack(
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
                    key: ValueKey(widget.video.coverHorizontal ?? ''),
                    sid: widget.video.coverHorizontal ?? '',
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
                        onTap: () {
                          print('👹👹👹 onTap');
                          _controller?.play();
                          setState(() {
                            hasError = false;
                          });
                        },
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
            )
          ] else if (_controller != null &&
              _controller!.value.isInitialized) ...[
            VideoPlayer(_controller!),
            // controls
            GestureDetector(
              onTap: () {
                setState(() {
                  isVisibleControls = true;
                });
                Timer(const Duration(seconds: 3), () {
                  if (mounted) {
                    setState(() {
                      isVisibleControls = false;
                    });
                  }
                });
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: isVisibleControls
                    ? Stack(
                        children: [
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle),
                              child: IconButton(
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 48.0,
                                ),
                                onPressed: () {
                                  print('onPressed 播放暫停');
                                  setState(() {
                                    if (_controller!.value.isPlaying) {
                                      _controller!.pause();
                                      setState(() {
                                        isPause = true;
                                      });
                                    } else {
                                      _controller!.play();
                                      setState(() {
                                        isPause = false;
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Stack(
                              children: <Widget>[
                                ValueListenableBuilder<VideoPlayerValue>(
                                  valueListenable: _controller!,
                                  builder: (context, value, _) =>
                                      VideoProgressSlider(
                                    position: value.position,
                                    duration: value.duration,
                                    controller: _controller!,
                                    swatch: const Color(0xffFFC700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
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

