import 'package:flutter/material.dart';
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
          : GestureDetector(
              onTap: () {
                controller.play();
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
              )),
    );
  }
}
