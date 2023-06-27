import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';

final logger = Logger();

class ControlsOverlay extends StatefulWidget {
  final String videoUrl;
  const ControlsOverlay({Key? key, required this.videoUrl}) : super(key: key);

  @override
  ControlsOverlayState createState() => ControlsOverlayState();
}

class ControlsOverlayState extends State<ControlsOverlay> {
  late ObservableVideoPlayerController ovpController;
  int videoDuration = 0; // 影片總長度
  int videoPosition = 0; // 影片目前進度

  @override
  void initState() {
    ovpController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);

    ovpController.videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {
          videoDuration = ovpController
              .videoPlayerController.value.duration.inSeconds
              .toInt();
          videoPosition = ovpController
              .videoPlayerController.value.position.inSeconds
              .toInt();
        });
      }
    });
    super.initState();
  }

  // 主動更新影片進度
  void updateVideoPosition(Duration newPosition) {
    ovpController.videoPlayerController.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var boxWidth = constraints.maxWidth;
      return GestureDetector(
        onHorizontalDragUpdate: (details) {
          int newPositionSeconds = videoPosition + details.delta.dx.toInt();
          // Make sure we are within the video duration
          if (newPositionSeconds < 0) newPositionSeconds = 0;
          if (newPositionSeconds > videoDuration) {
            newPositionSeconds = videoDuration;
          }

          updateVideoPosition(Duration(seconds: newPositionSeconds));
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Text('boxWidth: $boxWidth'),
                  Text('videoDurationInSeconds: $videoDuration'),
                  Text('videoPositionInSeconds: $videoPosition'),
                ],
              ),
            )),
            Positioned(
              bottom: 0,
              child: Slider(
                value: videoPosition.toDouble(),
                min: 0,
                max: videoDuration.toDouble(),
                onChanged: (double value) {
                  updateVideoPosition(Duration(seconds: value.toInt()));
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
