import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_shorts_controller.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';

import 'next_video.dart';
import 'purchase.dart';
import 'supplier_name.dart';
import 'video_progress.dart';
import 'video_tags.dart';
import 'video_title.dart';

class ShortCardInfo extends StatefulWidget {
  final String videoUrl;
  final ShortVideoDetail data;
  final String title;
  final String tag;
  final bool displayActorAvatar;
  final String controllerTag;

  const ShortCardInfo({
    Key? key,
    required this.videoUrl,
    required this.data,
    required this.title,
    required this.tag,
    this.displayActorAvatar = true,
    required this.controllerTag,
  }) : super(key: key);

  @override
  _ShortCardInfoState createState() => _ShortCardInfoState();
}

class _ShortCardInfoState extends State<ShortCardInfo> {
  Vod? nextVideo;

  void _setupNextVideo() {
    final VideoShortsController videoShortsController =
        Get.find<VideoShortsController>(tag: widget.controllerTag);
    final int index = videoShortsController.data
        .indexWhere((element) => element.id == widget.data.id);
    setState(() {
      nextVideo = videoShortsController.data[index + 1];
    });
  }

  @override
  void initState() {
    _setupNextVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
        tag: widget.videoUrl,
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
            padding:
                const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SupplierNameWidget(
                  data: widget.data,
                  displayActorAvatar: widget.displayActorAvatar,
                  videoPlayerInfo: videoPlayerInfo,
                ),
                VideoTitleWidget(title: widget.title),
                VideoTagsWidget(
                  data: widget.data,
                  videoPlayerInfo: videoPlayerInfo,
                ),
                PurchaseWidget(
                  vodId: widget.data.id,
                  tag: widget.tag,
                ),
                VideoProgressWidget(
                  videoPlayerController: videoPlayerInfo.videoPlayerController!,
                ),
                NextVideoWidget(video: nextVideo),
              ],
            ),
          );
        });
  }
}
