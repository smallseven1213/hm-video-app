import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import '../short/short_card_info_tag.dart';


class VideoTagsWidget extends StatelessWidget {
  final ShortVideoDetail data;
  final VideoPlayerInfo videoPlayerInfo;

  VideoTagsWidget({
    required this.data,
    required this.videoPlayerInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (data.tag.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 4,
        runSpacing: 4,
        children: data.tag
            .map((e) => GestureDetector(
                  onTap: () async {
                    videoPlayerInfo
                        .observableVideoPlayerController.videoPlayerController
                        ?.pause();
                    await MyRouteDelegate.of(context).push(
                      AppRoutes.supplierTag,
                      args: {'tagId': e.id, 'tagName': e.name},
                      removeSamePath: true,
                    );
                    videoPlayerInfo
                        .observableVideoPlayerController.videoPlayerController
                        ?.play();
                  },
                  child: ShortCardInfoTag(name: '#${e.name}'),
                ))
            .toList(),
      ),
    );
  }
}
