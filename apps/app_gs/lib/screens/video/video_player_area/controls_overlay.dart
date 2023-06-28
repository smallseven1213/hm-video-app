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
  String videoDurationString = '';
  int videoDuration = 0; // 影片總長度
  int videoPosition = 0; // 影片目前進度
  bool displayControls = false; // 是否要呈現影片控制區塊

  @override
  void initState() {
    ovpController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);

    ovpController.videoPlayerController.addListener(() {
      if (mounted && ovpController.videoPlayerController.value.isInitialized) {
        setState(() {
          videoDurationString = ovpController
              .videoPlayerController.value.duration
              .toString()
              .split('.')
              .first;
          // 將videoDurationString的HH MM SS拆出來，最後換算成秒數
          List<String> durationList = videoDurationString.split(':');
          if (durationList.length == 3) {
            videoDuration = int.parse(durationList[0]) * 3600 +
                int.parse(durationList[1]) * 60 +
                int.parse(durationList[2]);
          } else if (durationList.length == 2) {
            videoDuration =
                int.parse(durationList[0]) * 60 + int.parse(durationList[1]);
          } else {
            videoDuration = int.parse(durationList[0]);
          }
          // videoDuration = ovpController
          //     .videoPlayerController.value.duration.inSeconds
          //     .toInt();
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

  void toggleDisplayControls() {
    setState(() {
      displayControls = !displayControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: toggleDisplayControls,
        onHorizontalDragUpdate: (details) {
          int newPositionSeconds = videoPosition + details.delta.dx.toInt();

          if (newPositionSeconds < 0) newPositionSeconds = 0;
          if (newPositionSeconds > videoDuration) {
            newPositionSeconds = videoDuration;
          }
          if (!displayControls) {
            toggleDisplayControls();
          }

          updateVideoPosition(Duration(seconds: newPositionSeconds));
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                child: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  color: Colors.transparent,
                )),
            if (displayControls)
              // 下方控制區塊
              Positioned(
                bottom: 0,
                child: Row(
                  children: [
                    Slider(
                      value: videoPosition.toDouble(),
                      min: 0,
                      max: videoDuration.toDouble(),
                      onChanged: (double value) {
                        updateVideoPosition(Duration(seconds: value.toInt()));
                        // setState(() {
                        //   sliderPosition = value.toInt();
                        // });
                      },
                    )
                  ],
                ),
              )
          ],
        ),
      );
    });
  }
}
