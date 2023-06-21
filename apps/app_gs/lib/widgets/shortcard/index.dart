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
import 'package:shared/widgets/video_player/progress.dart';
import 'package:shared/widgets/video_player/video_cover.dart';
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
              child: Stack(children: [
                if (obsVideoPlayerController.isReady.value &&
                    !isLoading &&
                    videoUrl.isNotEmpty &&
                    video != null &&
                    obsVideoPlayerController
                        .videoPlayerController.value.isInitialized)
                  AspectRatio(
                    aspectRatio: obsVideoPlayerController
                        .videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(
                        obsVideoPlayerController.videoPlayerController!),
                  )
                else
                  Container(color: Colors.black) // or a loading indicator
              ]),
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
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable:
                    obsVideoPlayerController.videoPlayerController!,
                builder: (context, value, _) => VideoProgressSlider(
                  controller: obsVideoPlayerController.videoPlayerController!,
                  position: value.position,
                  duration: value.duration,
                  swatch: const Color(0xffFFC700),
                  trackHeight: trackHeight,
                  onChangeStart: (value) => setState(() {
                    trackHeight = 4;
                  }),
                  onChangeEnd: (value) => setState(() {
                    trackHeight = 2;
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
