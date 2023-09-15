import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import '../../screens/short/short_card_info_tag.dart';
import '../actor_avatar.dart';

final logger = Logger();

class ShortCardInfo extends StatelessWidget {
  final ShortVideoDetail data;
  final String title;
  final String tag;
  final bool displayActorAvatar;

  const ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
    required this.tag,
    this.displayActorAvatar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
        tag: tag,
        child: (VideoPlayerInfo videoPlayerInfo) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.supplier != null) ...[
                  GestureDetector(
                    onTap: () async {
                      videoPlayerInfo
                          .observableVideoPlayerController.videoPlayerController
                          ?.pause();
                      await MyRouteDelegate.of(context)
                          .push(AppRoutes.supplier, args: {
                        'id': data.supplier!.id,
                      });
                      videoPlayerInfo
                          .observableVideoPlayerController.videoPlayerController
                          ?.play();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        displayActorAvatar == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                child: ActorAvatar(
                                  photoSid: data.supplier!.photoSid,
                                  width: 40,
                                  height: 40,
                                ))
                            : const SizedBox(),
                        Text(
                            '${displayActorAvatar == true ? '' : '@'}${data.supplier!.aliasName}',
                            style: TextStyle(
                              fontSize: displayActorAvatar == true ? 13 : 15,
                              color: Colors.white,
                            )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (data.tag.isNotEmpty)
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: data.tag
                        .map((e) => GestureDetector(
                            onTap: () async {
                              videoPlayerInfo.observableVideoPlayerController
                                  .videoPlayerController
                                  ?.pause();
                              await MyRouteDelegate.of(context).push(
                                  AppRoutes.supplierTag,
                                  args: {'tagId': e.id, 'tagName': e.name});
                              videoPlayerInfo.observableVideoPlayerController
                                  .videoPlayerController
                                  ?.play();
                            },
                            child: ShortCardInfoTag(name: '#${e.name}')))
                        .toList(),
                  ),
              ],
            ),
          );
        });
  }
}
