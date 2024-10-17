import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import '../actor_avatar.dart';

class SupplierNameWidget extends StatelessWidget {
  final Vod data;
  final bool showAvatar;
  final VideoPlayerInfo videoPlayerInfo;

  const SupplierNameWidget({
    super.key,
    required this.data,
    required this.showAvatar,
    required this.videoPlayerInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (data.supplier == null) {
      return Container();
    }
    return GestureDetector(
      onTap: () async {
        videoPlayerInfo.observableVideoPlayerController.videoPlayerController
            ?.pause();
        await MyRouteDelegate.of(context).push(AppRoutes.supplier, args: {
          'id': data.supplier!.id,
        });
        videoPlayerInfo.observableVideoPlayerController.videoPlayerController
            ?.play();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            showAvatar == true
                ? Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                    child: ActorAvatar(
                      photoSid: data.supplier!.photoSid,
                      width: 40,
                      height: 40,
                    ))
                : const SizedBox(),
            Text(
              '${showAvatar == true ? '' : '@'}${data.supplier!.aliasName}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
