import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_control/volume_control.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'enums.dart';
import 'play_pause_button.dart';
import 'player_header.dart';
import 'progress_bar.dart';
import 'progress_status.dart';
import 'volume_brightness.dart';
import 'screen_lock.dart';

final logger = Logger();

class ControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;
  final String? name;
  final Function toggleFullscreen;
  final Function onScreenLock;
  final bool isFullscreen;
  final bool isPlaying;
  final bool isScreenLocked;

  const ControlsOverlay({
    super.key,
    required this.controller,
    this.name,
    required this.isPlaying,
    required this.toggleFullscreen,
    required this.onScreenLock,
    required this.isFullscreen,
    required this.isScreenLocked,
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
  double? lastDragPosition; // 添加一个类变量来保存上次触发音量更改的滑动位置

  bool isForward = false;

  Future<void> setVolume(double volume) async {
    VolumeControl.setVolume(volume);
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
      Future.delayed(const Duration(seconds: 3), () {
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
      var screenWidth = MediaQuery.of(context).size.width;
      return GestureDetector(
        onTap: () {
          setState(() {
            controlsType = ControlsOverlayType.progress;
          });
          startCountdown();
        },
        onDoubleTap: () {
          widget.isPlaying
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
          bool isVolume =
              details.globalPosition.dx > MediaQuery.of(context).size.width / 2;
          initialVolume = widget.controller.value.volume;
          initialBrightness =
              MediaQuery.of(context).platformBrightness.index.toDouble();

          double brightness = await ScreenBrightness().current;

          setState(() {
            startVerticalDragY =
                isVolume ? details.globalPosition.dy : brightness;
            sideControlsType =
                isVolume ? SideControlsType.sound : SideControlsType.brightness;
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
          bool isVolume =
              details.globalPosition.dx > MediaQuery.of(context).size.width / 2;
          final globalPosition = details.globalPosition;
          final box = context.findRenderObject()! as RenderBox;
          final Offset tapPos = box.globalToLocal(globalPosition);
          final double relative =
              math.min(1.0, math.max(0.0, tapPos.dy / box.size.height));

          // final deltaY = startVerticalDragY - details.globalPosition.dy;
          // const sensitivity = 0.05;
          // final percentageDelta = deltaY / box.size.height;

          // Adjust volume when swipe on the right side of the screen
          if (isVolume) {
            // 檢查lastDragPosition是否為null，如果是，則初始化它
            lastDragPosition ??= details.globalPosition.dy;
            // 計算滑動距離
            double deltaY = details.globalPosition.dy - lastDragPosition!;
            // 設置滑動閾值，例如3個像素
            double threshold = 3;
            // 檢查滑動距離是否超過閾值
            if (deltaY.abs() >= threshold) {
              if (deltaY > 0) {
                if (widget.controller.value.volume <= 0) return;
                double volume = widget.controller.value.volume - 0.015;
                setVolume(volume);
              } else {
                if (widget.controller.value.volume >= 1) return;
                double volume = widget.controller.value.volume + 0.015;
                setVolume(volume);
              }
              // 更新lastDragPosition以便于下次计算
              lastDragPosition = details.globalPosition.dy;
            }
          } else {
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
          if (newPositionSeconds >= 0 && newPositionSeconds <= videoDuration) {
            final newPosition = Duration(seconds: newPositionSeconds.round());
            widget.controller.seekTo(newPosition);
          }
          // Determine whether the video is fast-forwarding or rewinding
          // setState(() {
          //   isForward = percentageDelta < 0;
          //   controlsType = ControlsOverlayType.middleTime;
          // });
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
              opacity: !widget.isPlaying ||
                      controlsType == ControlsOverlayType.playPause
                  ? 1.0
                  : 0.0,
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
            if (widget.isFullscreen &&
                !kIsWeb &&
                (controlsType == ControlsOverlayType.progress ||
                    controlsType == ControlsOverlayType.middleTime ||
                    controlsType == ControlsOverlayType.playPause))
              ScreenLock(
                  isScreenLocked: widget.isScreenLocked,
                  onScreenLock: widget.onScreenLock),
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
      );
    });
  }
}
