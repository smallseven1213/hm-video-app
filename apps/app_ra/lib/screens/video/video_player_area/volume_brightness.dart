import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'enums.dart';

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
