import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
