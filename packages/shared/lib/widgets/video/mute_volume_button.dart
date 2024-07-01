import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_player_controller.dart';

import '../../localization/shared_localization_delegate.dart';

class MuteVolumeButton extends StatelessWidget {
  final ObservableVideoPlayerController controller;

  const MuteVolumeButton({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return Obx(
      () => controller.isMuted.value
          ? SizedBox(
              width: 110,
              child: TextButton.icon(
                onPressed: () => controller.toggleMute(),
                icon: const Icon(Icons.volume_off, size: 14),
                label: Text(
                  localizations.translate('unmute'),
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                style: TextButton.styleFrom(
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
