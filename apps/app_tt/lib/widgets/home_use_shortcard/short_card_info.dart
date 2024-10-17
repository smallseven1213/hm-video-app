import 'package:flutter/material.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';

import '../shortcard/purchase.dart';
import '../shortcard/supplier_name.dart';
import '../shortcard/video_progress.dart';
import '../shortcard/video_tags.dart';
import '../shortcard/video_title.dart';

class ShortCardInfo extends StatelessWidget {
  final Vod data;
  final String title;
  final String tag;
  final bool showAvatar;

  const ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
    required this.tag,
    this.showAvatar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
        tag: tag,
        child: (VideoPlayerInfo videoPlayerInfo) {
          return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 1.51],
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SupplierNameWidget(
                        data: data,
                        showAvatar: showAvatar,
                        videoPlayerInfo: videoPlayerInfo,
                      ),
                      VideoTitleWidget(title: title),
                      VideoTagsWidget(
                        data: data,
                        videoPlayerInfo: videoPlayerInfo,
                      ),
                      PurchaseWidget(
                        vodId: data.id,
                        tag: tag,
                      ),
                      // const SizedBox(height: 30),
                      VideoProgressWidget(
                        videoPlayerController:
                            videoPlayerInfo.videoPlayerController!,
                      ),
                    ],
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: VideoProgressWidget(
                  //     videoPlayerController:
                  //         videoPlayerInfo.videoPlayerController!,
                  //   ),
                  // ),
                ],
              ));
        });
  }
}
