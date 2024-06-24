import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_player_controller.dart';

class ShortVideoMuteButton extends StatelessWidget {
  final ObservableVideoPlayerController controller;

  const ShortVideoMuteButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.toggleMute();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Image(
                image: AssetImage(controller.isMuted.value
                    ? 'packages/shared/assets/images/short-mute.webp'
                    : 'packages/shared/assets/images/short-unmute.webp'),
                fit: BoxFit.fill,
              )),
        ),
      ),
    );
  }
}
