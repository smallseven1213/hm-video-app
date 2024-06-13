import 'package:flutter/material.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';

import '../../../localization/i18n.dart';

class MuteVolumeButton extends StatelessWidget {
  final VideoPlayerInfo videoPlayerInfo;

  const MuteVolumeButton({
    super.key,
    required this.videoPlayerInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (videoPlayerInfo.isMuted) {
      return SizedBox(
        width: 110,
        child: TextButton.icon(
          onPressed: () => videoPlayerInfo.toggleMuteAndUpdateVolume(),
          icon: const Icon(Icons.volume_off, size: 14),
          label: Text(
            I18n.unmute,
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
          ), // Text
          style: TextButton.styleFrom(
            iconColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
