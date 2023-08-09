import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/pageview_index_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/video_player/player.dart';
import 'package:video_player/video_player.dart';
import '../../screens/short/fullscreen_controls.dart';
import '../wave_loading.dart';
import 'short_card_info.dart';

class ShortCard extends StatefulWidget {
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;
  final String obsKey;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;
  final bool? hiddenBottomArea;

  const ShortCard({
    Key? key,
    required this.obsKey,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    // required this.isFullscreen,
    this.isActive = true,
    this.supportedPlayRecord = true,
    this.displayFavoriteAndCollectCount = true,
    this.hiddenBottomArea = false,
  }) : super(key: key);

  @override
  ShortCardState createState() => ShortCardState();
}

class ShortCardState extends State<ShortCard> {
  late ShortVideoDetailController videoDetailController;
  double trackHeight = 2.0;
  double startHorizontalDragX = 0.0;
  final PageViewIndexController pageviewIndexController =
      Get.find<PageViewIndexController>();

  bool isDragging = false;

  @override
  void initState() {
    super.initState();

    videoDetailController = Get.find<ShortVideoDetailController>(
        tag: genaratorShortVideoDetailTag(widget.id.toString()));

    if (widget.supportedPlayRecord == true) {
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

    // obsVideoPlayerController =
    //     Get.find<ObservableVideoPlayerController>(tag: widget.obsKey);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (kIsWeb) {
    //   } else {
    //     obsVideoPlayerController.play();
    //   }
    // });
  }

  @override
  void dispose() {
    // obsVideoPlayerController.pause();
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

      return VideoPlayerProvider(
          tag: widget.obsKey,
          videoUrl: videoUrl,
          video: video!,
          videoDetail: Vod(
            video.id,
            video.title,
            coverHorizontal: video.coverHorizontal!,
            coverVertical: video.coverVertical!,
            timeLength: video.timeLength!,
            tags: video.tags!,
            videoViewTimes: video.videoViewTimes!,
          ),
          child: (isReady) => VideoPlayerConsumer(
                tag: widget.obsKey,
                child: (videoPlayerInfo) {
                  if (videoPlayerInfo.videoPlayerController == null) {
                    return Container();
                  }
                  if (pageviewIndexController.isFullscreen.value == true) {
                    Size videoSize =
                        videoPlayerInfo.videoPlayerController!.value.size;
                    var aspectRatio = videoSize.width /
                        (videoSize.height != 0.0 ? videoSize.height : 1);

                    return Stack(
                      children: [
                        if (isReady && !isLoading && videoUrl.isNotEmpty)
                          Center(
                            child: AspectRatio(
                              aspectRatio: aspectRatio,
                              child: VideoPlayer(
                                videoPlayerInfo.videoPlayerController!,
                              ),
                            ),
                          ),
                        FullScreenControls(
                          videoUrl: videoUrl,
                          isFullscreen:
                              pageviewIndexController.isFullscreen.value,
                          toggleFullscreen: () {
                            widget.toggleFullScreen();
                          },
                          videoPlayerInfo: videoPlayerInfo,
                          ovpController:
                              videoPlayerInfo.observableVideoPlayerController,
                        ),
                      ],
                    );
                  }
                  return Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        const WaveLoading(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                          duration: Duration(milliseconds: 1000),
                          size: 17,
                          itemCount: 3,
                        ),
                        SizedBox(
                          height:
                              screen.size.height - 76 - screen.padding.bottom,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              if (isReady && !isLoading && videoUrl.isNotEmpty)
                                VideoPlayerDisplayWidget(
                                  controller: videoPlayerInfo
                                      .observableVideoPlayerController,
                                  video: video,
                                  allowFullsreen: false,
                                  toggleFullscreen: () {
                                    widget.toggleFullScreen();
                                  },
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
                          bottom: widget.hiddenBottomArea == true
                              ? -16
                              : 60 + screen.padding.bottom,
                          left: 0,
                          right: 0,
                          child: Listener(
                            onPointerDown: (details) {
                              setState(() {
                                isDragging = true;
                              });
                            },
                            onPointerUp: (details) {
                              setState(() {
                                isDragging = false;
                              });
                            },
                            child: RawGestureDetector(
                              gestures: <Type, GestureRecognizerFactory>{
                                HorizontalDragGestureRecognizer:
                                    GestureRecognizerFactoryWithHandlers<
                                        HorizontalDragGestureRecognizer>(
                                  () => HorizontalDragGestureRecognizer(),
                                  (HorizontalDragGestureRecognizer instance) {
                                    instance
                                      ..onStart = (DragStartDetails details) {
                                        // 可以处理拖动开始的事件
                                      }
                                      ..onUpdate = (DragUpdateDetails details) {
                                        // 可以处理拖动更新的事件
                                      }
                                      ..onEnd = (DragEndDetails details) {
                                        // 可以处理拖动结束的事件
                                      };
                                  },
                                ),
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: isDragging ? 40 : 35,
                                child: VideoProgressIndicator(
                                  videoPlayerInfo.videoPlayerController!,
                                  allowScrubbing: true,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  colors: VideoProgressColors(
                                    playedColor: const Color(0xffFFC700),
                                    bufferedColor: Colors.grey,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const FloatPageBackButton()
                      ],
                    ),
                  );
                },
              ));
    });
  }
}
