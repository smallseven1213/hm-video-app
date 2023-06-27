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

  @override
  void initState() {
    ovpController =
        Get.find<ObservableVideoPlayerController>(tag: widget.videoUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var boxWidth = constraints.maxWidth;
      return Obx(() {
        // 影片總時長
        final double videoDurationInSeconds = ovpController
            .videoPlayerController.value.duration.inSeconds
            .toDouble();
        // 目前播到的位置
        final double videoPositionInSeconds = ovpController
            .videoPlayerController.value.position.inSeconds
            .toDouble();
        return GestureDetector(
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Text('boxWidth: $boxWidth'),
                    Text('videoDurationInSeconds: $videoDurationInSeconds'),
                    Text('videoPositionInSeconds: $videoPositionInSeconds'),
                  ],
                ),
              ))
            ],
          ),
        );
      });
    });
  }
}
