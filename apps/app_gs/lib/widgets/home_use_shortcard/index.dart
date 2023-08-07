import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import '../shortcard/index.dart';
import '../wave_loading.dart';
import 'side_info.dart';

final logger = Logger();

class HomeUseShortCard extends StatefulWidget {
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

  const HomeUseShortCard({
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
  HomeUseShortCardState createState() => HomeUseShortCardState();
}

class HomeUseShortCardState extends State<HomeUseShortCard> {
  @override
  Widget build(BuildContext context) {
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
          ShortCard(
            obsKey: widget.obsKey,
            index: widget.index,
            isActive: widget.isActive,
            id: widget.shortData.id,
            title: widget.shortData.title,
            shortData: widget.shortData,
            toggleFullScreen: widget.toggleFullScreen,
            hiddenBottomArea: widget.hiddenBottomArea,
          ),
          SideInfo(
            obsKey: widget.obsKey,
            shortData: widget.shortData,
          ),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}


/*
class ShortCardStyle2 extends StatefulWidget {
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;
  final String obsKey;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;

  const ShortCardStyle2({
    Key? key,
    required this.obsKey,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    this.isActive = true,
    this.supportedPlayRecord = true,
    this.displayFavoriteAndCollectCount = true,
  }) : super(key: key);

  @override
  ShortCardStyle2State createState() => ShortCardStyle2State();
}

class ShortCardStyle2State extends State<ShortCardStyle2> {
  late ShortVideoDetailController videoDetailController;
  late ObservableVideoPlayerController obsVideoPlayerController;
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

    if (widget.isActive == false) {
      obsVideoPlayerController.pause();
    } else {
      if (!kIsWeb) {
        obsVideoPlayerController.play();
      }
    }

    return Obx(() {
      var isLoading = videoDetailController.isLoading.value;
      var video = videoDetailController.video.value;
      var videoDetail = videoDetailController.videoDetail.value;
      var videoUrl = videoDetailController.videoUrl.value;

      if (pageviewIndexController.isFullscreen.value == true && video != null) {
        Size videoSize =
            obsVideoPlayerController.videoPlayerController.value.size;
        var aspectRatio =
            videoSize.width / (videoSize.height != 0.0 ? videoSize.height : 1);

        return Stack(
          children: [
            if (obsVideoPlayerController.isReady.value &&
                !isLoading &&
                videoUrl.isNotEmpty)
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(
                    obsVideoPlayerController.videoPlayerController,
                  ),
                ),
              ),
            FullScreenControls(
              videoUrl: videoUrl,
              isFullscreen: pageviewIndexController.isFullscreen.value,
              toggleFullscreen: () {
                widget.toggleFullScreen();
              },
              ovpController: obsVideoPlayerController,
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
              height: screen.size.height - 76 - screen.padding.bottom,
              width: double.infinity,
              child: Stack(
                children: [
                  if (obsVideoPlayerController.isReady.value &&
                      !isLoading &&
                      videoUrl.isNotEmpty &&
                      video != null)
                    VideoPlayerDisplayWidget(
                      controller: obsVideoPlayerController,
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
                  if (videoDetail != null)
                    SideInfo(
                      obsKey: widget.obsKey,
                      data: videoDetail,
                      title: widget.title,
                      videoUrl: videoUrl,
                      shortData: widget.shortData,
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: -17,
              left: -24,
              right: -24,
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
                      obsVideoPlayerController.videoPlayerController,
                      allowScrubbing: true,
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
            ),
            const FloatPageBackButton()
          ],
        ),
      );
    });
  }
}
*/