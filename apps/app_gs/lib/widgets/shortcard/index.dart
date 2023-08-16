import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/pageview_index_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/video_player/error.dart';
import 'package:shared/widgets/video_player/player.dart';
import 'package:video_player/video_player.dart';
import '../../screens/short/fullscreen_controls.dart';

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
  final bool allowFullsreen;

  const ShortCard({
    Key? key,
    required this.obsKey,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    required this.allowFullsreen,
    // required this.isFullscreen,
    this.isActive = true,
    this.supportedPlayRecord = true,
    this.displayFavoriteAndCollectCount = true,
  }) : super(key: key);

  @override
  ShortCardState createState() => ShortCardState();
}

class ShortCardState extends State<ShortCard> {
  final PageViewIndexController pageviewIndexController =
      Get.find<PageViewIndexController>();
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return VideoPlayerConsumer(
      tag: widget.obsKey,
      child: (VideoPlayerInfo videoPlayerInfo) {
        if (videoPlayerInfo.videoPlayerController == null) {
          return Container();
        }
        if (pageviewIndexController.isFullscreen.value == true) {
          Size videoSize = videoPlayerInfo.videoPlayerController!.value.size;
          var aspectRatio = videoSize.width /
              (videoSize.height != 0.0 ? videoSize.height : 1);
          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio > 1.0 ? aspectRatio : 16 / 9,
                  child: VideoPlayer(
                    videoPlayerInfo.videoPlayerController!,
                  ),
                ),
              ),
              FullScreenControls(
                videoPlayerInfo: videoPlayerInfo,
                pageviewIndexController: pageviewIndexController,
              ),
              // error

              if (videoPlayerInfo
                      .observableVideoPlayerController.videoAction.value ==
                  'error')
                ShortVideoConsumer(
                  vodId: widget.id,
                  child: ({
                    required isLoading,
                    required video,
                    required videoDetail,
                    required videoUrl,
                  }) =>
                      VideoError(
                          videoCover: video!.coverVertical ?? '',
                          onTap: () => videoPlayerInfo
                              .observableVideoPlayerController
                              .videoPlayerController
                              ?.play()),
                ),
            ],
          );
        }
        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              SizedBox(
                height: screen.size.height - 76 - screen.padding.bottom,
                width: double.infinity,
                child: ShortVideoConsumer(
                  vodId: widget.id,
                  child: ({
                    required isLoading,
                    required video,
                    required videoDetail,
                    required videoUrl,
                  }) =>
                      VideoPlayerDisplayWidget(
                    controller: videoPlayerInfo.observableVideoPlayerController,
                    video: video!,
                    allowFullsreen: widget.allowFullsreen,
                    toggleFullscreen: () {
                      pageviewIndexController.toggleFullscreen();
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: -16,
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
              // const FloatPageBackButton()
            ],
          ),
        );
      },
    );
  }
}
