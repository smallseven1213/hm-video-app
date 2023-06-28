import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import 'package:shared/widgets/video_player/player.dart';
import 'package:video_player/video_player.dart';
import '../short_bottom_area.dart';
import '../wave_loading.dart';
import 'short_card_info.dart';

final logger = Logger();

class ShortCard extends StatefulWidget {
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;
  final String obsKey;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;

  const ShortCard({
    Key? key,
    required this.obsKey,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    this.supportedPlayRecord = true,
    this.displayFavoriteAndCollectCount = true,
  }) : super(key: key);

  @override
  ShortCardState createState() => ShortCardState();
}

class ShortCardState extends State<ShortCard> {
  late ShortVideoDetailController videoDetailController;
  late ObservableVideoPlayerController obsVideoPlayerController;
  double trackHeight = 2.0;
  double startHorizontalDragX = 0.0;

  bool isDragging = false;

  @override
  void initState() {
    super.initState();

    videoDetailController = Get.find<ShortVideoDetailController>(
        tag: genaratorShortVideoDetailTag(widget.id.toString()));

    if (widget.supportedPlayRecord == true) {
      logger.i('PLAYRECORD TESTING: initial');
      var videoVal = videoDetailController.video.value;
      var playRecord = Vod(
        videoVal!.id,
        videoVal.title,
        coverHorizontal: videoVal.coverHorizontal!,
        coverVertical: videoVal.coverVertical!,
        timeLength: videoVal.timeLength!,
        tags: videoVal.tags!,
        videoViewTimes: videoVal.videoViewTimes!,
      );
      Get.find<PlayRecordController>(tag: 'short').addPlayRecord(playRecord);
    }

    obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: widget.obsKey);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
      } else {
        obsVideoPlayerController.play();
      }
    });
  }

  @override
  void dispose() {
    obsVideoPlayerController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    var screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      var isLoading = videoDetailController.isLoading.value;
      var video = videoDetailController.video.value;
      var videoDetail = videoDetailController.videoDetail.value;
      var videoUrl = videoDetailController.videoUrl.value;

      return Container(
        color: Colors.black,
        child: Stack(
          children: [
            SizedBox(
              height: screen.size.height - 76 - screen.padding.bottom,
              width: double.infinity,
              child: Stack(
                children: [
                  if (video != null)
                    const WaveLoading(
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                      duration: Duration(milliseconds: 1000),
                      size: 17,
                      itemCount: 3,
                    ),
                  if (obsVideoPlayerController.isReady.value &&
                      !isLoading &&
                      videoUrl.isNotEmpty &&
                      video != null)
                    VideoPlayerDisplayWidget(
                      controller: obsVideoPlayerController,
                      video: video,
                    ),
                  if (videoDetail != null)
                    ShortCardInfo(
                      obsKey: widget.obsKey,
                      data: videoDetail,
                      title: widget.title,
                      videoUrl: videoUrl,
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ShortBottomArea(
                shortData: widget.shortData,
                displayFavoriteAndCollectCount:
                    widget.displayFavoriteAndCollectCount,
              ),
            ),
            Positioned(
              bottom: 52 + screen.padding.bottom,
              left: -24,
              right: -24,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final box = context.findRenderObject()! as RenderBox;
                  final deltaX =
                      startHorizontalDragX - details.globalPosition.dx;
                  final percentageDelta = deltaX / box.size.width;
                  final videoDuration = obsVideoPlayerController
                      .videoPlayerController.value.duration.inSeconds;
                  final newPositionSeconds = obsVideoPlayerController
                          .videoPlayerController.value.position.inSeconds -
                      (videoDuration * percentageDelta);

                  // 拖動影片進度
                  if (newPositionSeconds >= 0 &&
                      newPositionSeconds <= videoDuration) {
                    final newPosition =
                        Duration(seconds: newPositionSeconds.round());
                    obsVideoPlayerController.videoPlayerController
                        .seekTo(newPosition);
                  }
                  startHorizontalDragX = details.globalPosition.dx;
                },
                onHorizontalDragStart: (details) {
                  startHorizontalDragX = details.globalPosition.dx;
                  setState(() {
                    isDragging = true;
                  });
                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    isDragging = false;
                  });
                },
                child: AnimatedContainer(
                  color: Colors.white.withOpacity(0),
                  duration: const Duration(milliseconds: 300),
                  height: isDragging ? 40 : 35,
                  child: VideoProgressIndicator(
                    obsVideoPlayerController.videoPlayerController,
                    allowScrubbing: false,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    colors: VideoProgressColors(
                      playedColor: const Color(0xffFFC700),
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
