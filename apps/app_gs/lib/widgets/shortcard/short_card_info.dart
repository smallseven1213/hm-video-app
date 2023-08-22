import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import '../../screens/short/short_card_info_tag.dart';

final logger = Logger();

class ShortCardInfo extends StatelessWidget {
  final ShortVideoDetail data;
  final String title;

  const ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
        tag: data.id.toString(),
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
                        ActorAvatar(
                          photoSid: data.supplier!.photoSid,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        const SizedBox(height: 8),
                        Text(data.supplier!.aliasName ?? '',
                            style: const TextStyle(
                              fontSize: 13,
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
