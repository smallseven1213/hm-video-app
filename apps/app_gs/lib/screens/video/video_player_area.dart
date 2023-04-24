import 'dart:math' as math;
// VideoPlayerArea stateful widget
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/video.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/screen_control.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_control/volume_control.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock/wakelock.dart';

enum ControlsOverlayType { none, progress, playPause, middleTime }

enum SideControlsType { none, sound, brightness }

class DotLineAnimation extends StatefulWidget {
  const DotLineAnimation({super.key});

  @override
  _DotLineAnimationState createState() => _DotLineAnimationState();
}

class _DotLineAnimationState extends State<DotLineAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDot(_animation.value),
        const SizedBox(width: 8),
        buildLine(_animation.value),
        const SizedBox(width: 8),
        buildDot(1 - _animation.value),
      ],
    );
  }

  Widget buildDot(double scale) {
    return Container(
        width: 5 * scale,
        height: 5 * scale,
        decoration: BoxDecoration(
            color: Color(0xffF4D743),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xffF4D743).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]));
  }

  Widget buildLine(double scale) {
    return Container(
      width: 15 * scale + 5,
      height: 5,
      decoration: BoxDecoration(
          color: Color(0xffF4D743),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Color(0xffF4D743).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ]),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final VideoPlayerController controller;
  const PlayPauseButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
      child: controller.value.isPlaying
          ? const SizedBox.shrink()
          : Center(
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
    );
  }
}

class ProgressStatus extends StatelessWidget {
  final bool isForward;
  final VideoPlayerController controller;
  const ProgressStatus({
    super.key,
    required this.controller,
    required this.isForward,
  });

  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;
    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: <InlineSpan>[
            WidgetSpan(
              child: Icon(
                isForward
                    ? Icons.keyboard_double_arrow_right
                    : Icons.keyboard_double_arrow_left,
                color: Colors.white,
                size: 16,
              ),
            ),
            TextSpan(
              text: formatDuration(controller.value.position),
              style: const TextStyle(
                fontSize: 13.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ' / ${formatDuration(controller.value.duration)}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white.withOpacity(.75),
                fontWeight: FontWeight.normal,
              ),
            )
          ],
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final VideoPlayerController controller;
  final Function toggleFullscreen;
  final bool isFullscreen;
  final double opacity;
  const ProgressBar({
    super.key,
    required this.controller,
    required this.toggleFullscreen,
    required this.isFullscreen,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: isFullscreen ? 30 : 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  },
                  icon: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 18,
                  ),
                );
              },
            ),
            Text(
              controller.value.position.toString().split('.')[0],
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                colors: VideoProgressColors(
                  playedColor: Colors.blue,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(width: 5.0),
            Text(
              controller.value.duration.toString().split('.')[0],
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              onPressed: () => toggleFullscreen(),
              icon: Icon(
                  isFullscreen
                      ? Icons.close_fullscreen_rounded
                      : Icons.fullscreen,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class VolumeBrightness extends StatelessWidget {
  final VideoPlayerController controller;
  final SideControlsType sideControlsType;

  final double verticalDragPosition;
  final double height;

  const VolumeBrightness({
    super.key,
    required this.controller,
    required this.sideControlsType,
    required this.verticalDragPosition,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height * .25,
      right: sideControlsType == SideControlsType.brightness ? 10 : null,
      left: sideControlsType == SideControlsType.sound ? 10 : null,
      child: Container(
        width: 20,
        height: height * 0.5,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black45,
        ),
        child: Column(
          children: [
            Expanded(
              child: RotatedBox(
                quarterTurns: -1,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  value: verticalDragPosition,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Icon(
              sideControlsType == SideControlsType.sound
                  ? verticalDragPosition == 0
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded
                  : verticalDragPosition == 0
                      ? Icons.wb_sunny_rounded
                      : Icons.wb_sunny_outlined,
              color: Colors.white,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerHeader extends StatelessWidget {
  final String? title;
  final bool isFullscreen;
  final Function toggleFullscreen;

  const PlayerHeader({
    super.key,
    this.title,
    required this.isFullscreen,
    required this.toggleFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        title: Text(title ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            )),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
          onPressed: () {
            if (isFullscreen) {
              toggleFullscreen(false);
            } else {
              toggleFullscreen(false);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

class VideoPlayerArea extends StatefulWidget {
  final int id;
  final String? name;
  final String videoUrl;
  final Video video;
  VideoPlayerController? controller;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializePlayer();
  }

  void initializePlayer() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl);
      _controller!.addListener(() {
        if (_controller!.value.hasError) {
          setState(() {
            hasError = true;
          });
        }
        if (_controller!.value.isBuffering) {
          print('👹👹👹 isBuffering');
        }
        setState(() {});
      });
      _controller!.setLooping(true);
      await _controller!.initialize();
      setState(() {});
      await _controller!.play();
    } catch (error) {
      print('👹👹👹 Error occurred: $error');
      if (_controller!.value.hasError) {
        setState(() {
          hasError = true;
        });
      }
      // 這裡可以進一步處理錯誤，例如重試或顯示錯誤信息給用戶
    }
  }

  void toggleFullscreen({bool fullScreen = false}) {
    if (fullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      restoreScreenRotation();
    }

    setState(() {
      isFullscreen = fullScreen;
    });
  }

  void _onControllerValueChanged() async {
    // if (_controller!.value.isPlaying) {
    //   // 保持屏幕亮度
    //   // var isLock = await Wakelock.enabled;
    //   // if (!isLock) {
    //   //   Wakelock.enable();
    //   // }
    //   Wakelock.enable();
    // } else {
    //   // 恢復正常屏幕行為
    //   Wakelock.disable();
    // }
  }

  Future<bool> onWillPop() async {
    // Pause the video & exit fullscreen when the back button is pressed
    _controller?.pause();
    toggleFullscreen(fullScreen: false);
    // Allow the navigation to continue
    return true;
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
    final orientation =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).orientation;
    // Size size = WidgetsBinding.instance.window.physicalSize;
    // print("@@@@@@@@@ didChangeMetrics: 寬：${size.width} 高：${size.height}");
    print('@@@@@@@@@ didChangeMetrics orientation: $orientation');
    if (orientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    setState(() {
      isFullscreen = orientation == Orientation.landscape;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller!.removeListener(_onControllerValueChanged);
    _controller?.dispose();
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
      restoreScreenRotation();
    } else {
      _controller?.play();
      setScreenRotation();
    }
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: playerHeight,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            if (hasError) ...[
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
                            setState(() {
                              hasError = false;
                            });
                            initializePlayer();
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
                ],
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
            ] else if (_controller != null &&
                _controller!.value.isInitialized) ...[
              AspectRatio(
                aspectRatio: _controller!.value.size.width /
                    _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
              ControlsOverlay(
                controller: _controller!,
                name: widget.video.title,
                isFullscreen: isFullscreen,
                toggleFullscreen: (status) {
                  toggleFullscreen(fullScreen: status);
                },
              ),
            ] else ...[
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
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
                ],
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
          ],
        ),
      ),
    );
  }
}

class ControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final String? name;
  final Function toggleFullscreen;
  final bool isFullscreen;

  const ControlsOverlay({
    super.key,
    required this.controller,
    this.name,
    required this.toggleFullscreen,
    required this.isFullscreen,
  });

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<ControlsOverlay> {
  ControlsOverlayType controlsType = ControlsOverlayType.none;
  SideControlsType sideControlsType = SideControlsType.none;
  double initialVolume = 0.0;
  double initialBrightness = 0.0;
  double startHorizontalDragX = 0.0;
  double startVerticalDragY = 0.0;
  double verticalDragPosition = 0.0;

  bool isForward = false;

  Future<void> setVolume(double volume) async {
    await VolumeControl.setVolume(volume);
    widget.controller.setVolume(volume);

    setState(() {
      sideControlsType = SideControlsType.sound;
      verticalDragPosition = volume;
    });
  }

  Future<void> setBrightness(double brightness) async {
    await ScreenBrightness().setScreenBrightness(brightness);
    setState(() {
      sideControlsType = SideControlsType.brightness;
      verticalDragPosition = brightness;
    });
  }

  void startCountdown() {
    if (controlsType == ControlsOverlayType.progress ||
        controlsType == ControlsOverlayType.playPause) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            controlsType = ControlsOverlayType.none;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return MouseRegion(
        child: GestureDetector(
          onTap: () {
            setState(() {
              controlsType = ControlsOverlayType.progress;
            });
            startCountdown();
          },
          onDoubleTap: () {
            widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play();
            setState(() {
              controlsType = ControlsOverlayType.playPause;
            });
            startCountdown();
          },
          onVerticalDragStart: (details) async {
            if (GetPlatform.isWeb) {
              return;
            }
            bool isVolume = details.globalPosition.dx >
                MediaQuery.of(context).size.width / 2;
            initialVolume = widget.controller.value.volume;
            initialBrightness =
                MediaQuery.of(context).platformBrightness.index.toDouble();

            double brightness = await ScreenBrightness().current;

            setState(() {
              startVerticalDragY =
                  isVolume ? details.globalPosition.dy : brightness;
              sideControlsType = isVolume
                  ? SideControlsType.sound
                  : SideControlsType.brightness;
            });

            if (isVolume) {
              double volume = await VolumeControl.volume;
              await setVolume(volume);
            } else {
              await setBrightness(brightness);
            }
          },
          onVerticalDragUpdate: (details) async {
            if (GetPlatform.isWeb) {
              return;
            }
            bool isVolume = details.globalPosition.dx >
                MediaQuery.of(context).size.width / 2;
            final globalPosition = details.globalPosition;
            final box = context.findRenderObject()! as RenderBox;
            final Offset tapPos = box.globalToLocal(globalPosition);
            final double relative =
                math.min(1.0, math.max(0.0, tapPos.dy / box.size.height));

            final deltaY = startVerticalDragY - details.globalPosition.dy;
            const sensitivity = 0.05;
            final percentageDelta = deltaY / box.size.height;

            // Adjust volume when swipe on the right side of the screen
            if (isVolume) {
              if (details.primaryDelta! > 0) {
                if (widget.controller.value.volume <= 0) return;
                double volume = widget.controller.value.volume - 0.01;
                await setVolume(volume);
              } else {
                if (widget.controller.value.volume >= 1) return;
                double volume = widget.controller.value.volume + 0.01;
                await setVolume(volume);
              }
            } else {
              // Adjust brightness when swipe on the left side of the screen
              // var current = await ScreenBrightness().current;
              // final newBrightness =
              //     (current + sensitivity * (percentageDelta)).clamp(0.0, 1.0);
              // await setBrightness(newBrightness);

              Future.microtask(() async {
                var current = await ScreenBrightness().current;
                verticalDragPosition = math.min(1.0,
                    math.max(0.0, current + (startVerticalDragY - relative)));
                await ScreenBrightness()
                    .setScreenBrightness(verticalDragPosition);
                setState(() {
                  startVerticalDragY = relative;
                });
              });
            }
          },
          onVerticalDragEnd: (details) {
            setState(() {
              sideControlsType = SideControlsType.none;
            });
          },
          onHorizontalDragStart: (details) {
            startHorizontalDragX = details.globalPosition.dx;
            setState(() {
              controlsType = ControlsOverlayType.middleTime;
            });
          },
          onHorizontalDragUpdate: (details) {
            final box = context.findRenderObject()! as RenderBox;
            final deltaX = startHorizontalDragX - details.globalPosition.dx;
            final percentageDelta = deltaX / box.size.width;
            final videoDuration = widget.controller.value.duration.inSeconds;
            final newPositionSeconds =
                widget.controller.value.position.inSeconds -
                    (videoDuration * percentageDelta);

            // 拖動影片進度
            if (newPositionSeconds >= 0 &&
                newPositionSeconds <= videoDuration) {
              final newPosition = Duration(seconds: newPositionSeconds.round());
              widget.controller.seekTo(newPosition);
            }
            // Determine whether the video is fast-forwarding or rewinding
            setState(() {
              isForward = percentageDelta < 0;
              controlsType = ControlsOverlayType.middleTime;
            });
            // Update the startHorizontalDragX to the current position
            startHorizontalDragX = details.globalPosition.dx;
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              controlsType = ControlsOverlayType.none;
            });
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.black12,
              ),
              // 點兩下出現：播放暫停鍵
              AnimatedOpacity(
                opacity:
                    controlsType == ControlsOverlayType.playPause ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: PlayPauseButton(controller: widget.controller),
              ),
              // 水平拖拉：顯示快進或快退：影片時間 (左右拖動才顯示，可控製影片秒數)
              if (controlsType == ControlsOverlayType.middleTime)
                ProgressStatus(
                    controller: widget.controller, isForward: isForward),
              // 點一下出現：底部控製區（播放鍵+已看時間+進度條+影片總長+全螢幕，拖拉進度條的時候也顯示影片時間）
              if (controlsType == ControlsOverlayType.progress ||
                  controlsType == ControlsOverlayType.middleTime ||
                  controlsType == ControlsOverlayType.playPause)
                PlayerHeader(
                  isFullscreen: widget.isFullscreen,
                  title: widget.name,
                  toggleFullscreen: widget.toggleFullscreen,
                ),
              ProgressBar(
                controller: widget.controller,
                toggleFullscreen: () =>
                    widget.toggleFullscreen(!widget.isFullscreen),
                isFullscreen: widget.isFullscreen,
                opacity: controlsType == ControlsOverlayType.progress ||
                        controlsType == ControlsOverlayType.middleTime ||
                        controlsType == ControlsOverlayType.playPause
                    ? 1.0
                    : 0.0,
              ),
              //  垂直拖拉：顯示音量或亮度，並顯示音量或亮度的數值，拖拉位置在右邊時左邊顯示音量，拖拉位置在左邊時右邊顯示亮度
              if (!GetPlatform.isWeb &&
                      sideControlsType == SideControlsType.brightness ||
                  sideControlsType == SideControlsType.sound)
                VolumeBrightness(
                  controller: widget.controller,
                  verticalDragPosition: verticalDragPosition,
                  sideControlsType: sideControlsType,
                  height: constraints.maxHeight,
                )
            ],
          ),
        ),
      );
    });
  }
}
