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
    return SizedBox(
      width: videoPlayerInfo.isMuted ? 110 : 80,
      child: TextButton.icon(
        onPressed: () => videoPlayerInfo.toggleMuteAndUpdateVolume(),
        icon: Icon(
          videoPlayerInfo.isMuted ? Icons.volume_off : Icons.volume_up,
          size: 14,
        ),
        label: Text(
          videoPlayerInfo.isMuted ? I18n.unmute : I18n.mute,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          ),
        ), // Text
        style: TextButton.styleFrom(
          iconColor: Colors.black,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
