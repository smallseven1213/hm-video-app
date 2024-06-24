import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_shorts_controller.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';

import '../shortcard/supplier_name.dart';
import '../shortcard/video_progress.dart';
import '../shortcard/video_tags.dart';
import '../shortcard/video_title.dart';
import 'app_download_ad.dart';
import 'next_video.dart';
import '../shortcard/purchase.dart';

class ShortCardInfo extends StatefulWidget {
  final ShortVideoDetail data;
  final String title;
  final String tag;
  final bool displayActorAvatar;
  final String? controllerTag;

  const ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
    required this.tag,
    this.displayActorAvatar = true,
    this.controllerTag,
  }) : super(key: key);

  @override
  ShortCardInfoState createState() => ShortCardInfoState();
}

class ShortCardInfoState extends State<ShortCardInfo> {
  Vod? nextVideo;
  int currentVideoIndex = 0;

  void _setupNextVideo() {
    final VideoShortsController videoShortsController =
        Get.find<VideoShortsController>(tag: widget.controllerTag);
    final int index = videoShortsController.data
        .indexWhere((element) => element.id == widget.data.id);

    if (videoShortsController.data.length - 1 >= index + 1) {
      setState(() {
        nextVideo = videoShortsController.data[index + 1];
        currentVideoIndex = index;
      });
    }
  }

  @override
  void initState() {
    if (widget.controllerTag != null && widget.controllerTag!.isNotEmpty) {
      _setupNextVideo();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
        tag: widget.tag,
        child: (VideoPlayerInfo videoPlayerInfo) {
          if (videoPlayerInfo.videoPlayerController == null) {
            return Container();
          }
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
                Stack(
                  children: [
                    if (widget.controllerTag != null &&
                        widget.controllerTag!.isNotEmpty)
                      NextVideoWidget(video: nextVideo),
                    if (currentVideoIndex != 0 && currentVideoIndex % 3 == 0)
                      AppDownloadAdWidget(videoIndex: currentVideoIndex),
                  ],
                )
              ],
            ),
          );
        });
  }
}
