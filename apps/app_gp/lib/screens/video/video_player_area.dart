// VideoPlayerArea stateful widget

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:video_player/video_player.dart';

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
          : Container(
              color: Colors.black26,
              child: const Center(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 100.0,
                  semanticLabel: 'Play',
                ),
              ),
            ),
    );
  }
}

class VideoTime extends StatelessWidget {
  const VideoTime({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        // text: '${formatDuration(position)} ',
        text: '00:00:00',
        children: <InlineSpan>[
          TextSpan(
            // text: '/ ${formatDuration(duration)}',
            text: '/ 00:00:00',
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
    );
  }
}

class ProgressBar extends StatelessWidget {
  final VideoPlayerController controller;
  const ProgressBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              },
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            Text(
              "${controller.value.position.toString().split('.')[0]}",
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Text(
              "${controller.value.duration.toString().split('.')[0]}",
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                // TODO: Add fullscreen functionality
              },
              icon: Icon(Icons.fullscreen, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerArea extends StatefulWidget {
  final int id;
  VideoPlayerArea({Key? key, required this.id}) : super(key: key);

  @override
  _VideoPlayerAreaState createState() => _VideoPlayerAreaState();
}

class _VideoPlayerAreaState extends State<VideoPlayerArea> {
  VideoPlayerController? _controller;
  final VodApi vodApi = VodApi();

  @override
  void initState() {
    super.initState();
    _getVodUrl();
    // initializePlayer();
  }

  void _getVodUrl() async {
    var vod = await vodApi.getVodUrl(widget.id);
    var videoUrl = vod.getVideoUrl();
    logger.i(videoUrl);
    // _controller = VideoPlayerController.asset(videoUrl!);
    // _controller!.addListener(() {
    //   setState(() {});
    // });
    // _controller!.setLooping(true);
    // _controller!.initialize().then((_) => setState(() {}));
    // _controller!.play();

    _controller = VideoPlayerController.network(videoUrl!);
    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.setLooping(true);
    _controller!.initialize().then((_) => setState(() {}));
    _controller!.play();
  }

  // Future<void> initializePlayer(String source, {bool force = true}) async {

  // }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        child: _controller != null && _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller!),
                    _ControlsOverlay(controller: _controller!),
                    // VideoProgressIndicator(_controller!, allowScrubbing: true),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;

  const _ControlsOverlay({required this.controller});

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

enum ControlsOverlayType { none, sound, brightness, progress }

class __ControlsOverlayState extends State<_ControlsOverlay> {
  bool _hideControls = true;
  double initialVolume = 0.0;
  double initialBrightness = 0.0;
  double verDragPos = 0.0;

  double startVerticalDragY = 0.0;
  ControlsOverlayType controlsType = ControlsOverlayType.sound;

  void _toggleControls() {
    setState(() {
      _hideControls = !_hideControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: GestureDetector(
        onTap: () {
          _toggleControls();
          widget.controller.value.isPlaying
              ? widget.controller.pause()
              : widget.controller.play();
        },
        onVerticalDragStart: (details) {
          startVerticalDragY = details.globalPosition.dy;
          initialVolume = widget.controller.value.volume;
          initialBrightness =
              MediaQuery.of(context).platformBrightness.index.toDouble();
          print('onVerticalDragStart: ${startVerticalDragY}');
        },
        onVerticalDragUpdate: (details) {
          final box = context.findRenderObject()! as RenderBox;
          const sensitivity = 2;
          final deltaY = startVerticalDragY - details.globalPosition.dy;
          final percentageDelta = deltaY / box.size.height;

          // Adjust volume when swipe on the right side of the screen
          if (details.globalPosition.dx >
              MediaQuery.of(context).size.width / 2) {
            final newVolume =
                (initialVolume + sensitivity * percentageDelta).clamp(0.0, 1.0);
            widget.controller.setVolume(newVolume);
            setState(() {
              controlsType = ControlsOverlayType.sound;
              verDragPos = newVolume;
            });
          }
          // Adjust brightness when swipe on the left side of the screen
          else {
            final newBrightness =
                (initialBrightness + sensitivity * percentageDelta)
                    .clamp(0.0, 1.0);
            setState(() {
              controlsType = ControlsOverlayType.brightness;
              verDragPos = newBrightness;
            });
            // SystemChrome.setScreenBrightness(newBrightness);
          }
        },
        onVerticalDragEnd: (details) {
          setState(() {
            controlsType = ControlsOverlayType.none;
          });
        },
        onHorizontalDragStart: (details) {
          startVerticalDragY = details.globalPosition.dy;
          print('onHorizontalDragStart: ${startVerticalDragY}');
          setState(() {
            controlsType = ControlsOverlayType.progress;
          });
        },
        onHorizontalDragUpdate: (details) {
          print('onHorizontalDragUpdate=======: ${details.globalPosition}');
        },
        onHorizontalDragEnd: (details) {
          setState(() {
            controlsType = ControlsOverlayType.none;
          });
        },
        child: Stack(
          children: <Widget>[
            Container(
              width: (context.findRenderObject() as RenderBox).size.width,
              height: (context.findRenderObject() as RenderBox).size.height,
              color: Colors.black12,
            ),
            // TODO: 點一下出現：播放暫停鍵
            PlayPauseButton(controller: widget.controller),
            // GestureDetector(),
            // TODO: 水平拖拉：顯示快進或快退：影片時間 (左右拖動才顯示，可控制影片秒數)
            // TODO: 點一下出現：底部控制區（播放鍵+已看時間+進度條+影片總長+全螢幕，拖拉進度條的時候也顯示影片時間）
            if (controlsType == ControlsOverlayType.progress)
              ProgressBar(controller: widget.controller),
            // TODO: 垂直拖拉：顯示音量或亮度，並顯示音量或亮度的數值，拖拉位置在右邊時左邊顯示音量，拖拉位置在左邊時右邊顯示亮度
            // if (!_hideSoundAndBrightness)
            if (controlsType == ControlsOverlayType.brightness ||
                controlsType == ControlsOverlayType.sound)
              Positioned(
                top:
                    (context.findRenderObject() as RenderBox).size.height * .25,
                right:
                    controlsType == ControlsOverlayType.brightness ? 10 : null,
                left: controlsType == ControlsOverlayType.sound ? 10 : null,
                child: Container(
                  width: 20,
                  height:
                      (context.findRenderObject() as RenderBox).size.height *
                          0.5,
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
                            value: verDragPos,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Text(
                      //   _verDragPos.toString(),
                      //   style: TextStyle(color: Colors.white, fontSize: 9),
                      // ),
                      Icon(
                        controlsType == ControlsOverlayType.sound
                            ? verDragPos == 0
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded
                            : verDragPos == 0
                                ? Icons.wb_sunny_rounded
                                : Icons.wb_sunny_outlined,
                        color: Colors.white,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),

            // Visibility(
            //   visible: true,
            //   child: Text(
            //     'Volume: ${(widget.controller.value.volume! * 100).toInt()}%',
            //     style: TextStyle(color: Colors.white, fontSize: 24),
            //   ),
            // )

            // Add a container to display the volume and brightness indicators

            // Container(
            //     alignment: Alignment.center,
            //     child: ValueListenableBuilder<double>(
            //       valueListenable: valueList(enable: true),
            //       builder: (context, value, child) {
            //         return Visibility(
            //           visible: value != null,
            //           child: Text(
            //             'Brightness: ${(value * 100).toInt()}%',
            //             style: TextStyle(color: Colors.white, fontSize: 24),
            //           ),
            //         );
            //       },
            //     )),
            // Container(
            //     alignment: Alignment.center,
            //     child: ValueListenableBuilder<double>(
            //       valueListenable: valueList(enable: true),
            //       builder: (context, value, child) {
            //         return Visibility(
            //           visible: value != null,
            //           child: Text(
            //             'Brightness: ${(value * 100).toInt()}%',
            //             style: TextStyle(color: Colors.white, fontSize: 24),
            //           ),
            //         );
            //       },
            //     )),
          ],
        ),
      ),
    );
  }
}
