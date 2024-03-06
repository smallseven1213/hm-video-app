import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import '../short/side_info.dart';
import '../shortcard/index.dart';
import '../loading_animation.dart';
import 'short_card_info.dart';

class GeneralShortCard extends StatefulWidget {
  final int index;
  final String tag;
  final int id;
  final String title;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;
  final String videoUrl;
  final String? controllerTag;

  const GeneralShortCard({
    Key? key,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    required this.videoUrl,
    required this.tag,
    // required this.isFullscreen,
    this.isActive = true,
    this.displayFavoriteAndCollectCount = true,
    this.controllerTag,
  }) : super(key: key);

  @override
  GeneralShortCardState createState() => GeneralShortCardState();
}

class GeneralShortCardState extends State<GeneralShortCard> {
  final UIController uiController = Get.find<UIController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (uiController.isFullscreen.value == true) {
        widget.toggleFullScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl.isEmpty) {
      return const LoadingAnimation();
    }
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          VideoPlayerProvider(
            key: Key(widget.videoUrl),
            tag: widget.videoUrl,
            autoPlay: kIsWeb ? false : true,
            videoUrl: widget.videoUrl,
            video: widget.shortData,
            videoDetail: Vod(
              widget.shortData.id,
              widget.shortData.title,
              coverHorizontal: widget.shortData.coverHorizontal!,
              coverVertical: widget.shortData.coverVertical!,
              timeLength: widget.shortData.timeLength!,
              tags: widget.shortData.tags!,
              videoViewTimes: widget.shortData.videoViewTimes!,
            ),
            loadingWidget: const Center(child: LoadingAnimation()),
            child: (isReady) => ShortCard(
              key: Key(widget.tag),
              index: widget.index,
              tag: widget.tag,
              videoUrl: widget.videoUrl,
              isActive: widget.isActive,
              id: widget.shortData.id,
              title: widget.shortData.title,
              shortData: widget.shortData,
              toggleFullScreen: widget.toggleFullScreen,
              allowFullsreen: true,
            ),
          ),
          Obx(
            () => uiController.isFullscreen.value == true
                ? const SizedBox.shrink()
                : Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: ShortVideoConsumer(
                      vodId: widget.id,
                      tag: widget.tag,
                      child: ({
                        required isLoading,
                        required video,
                        required videoDetail,
                        required videoUrl,
                      }) =>
                          Column(
                        children: [
                          videoDetail != null
                              ? ShortCardInfo(
                                  key: Key(videoUrl!),
                                  videoUrl: videoUrl,
                                  tag: widget.tag,
                                  data: videoDetail,
                                  title: widget.title,
                                  displayActorAvatar: false,
                                  controllerTag: widget.controllerTag ?? "",
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
          ),
          SideInfo(
            videoId: widget.id,
            shortData: widget.shortData,
            tag: widget.tag,
            videoUrl: widget.videoUrl,
          ),
          Obx(
            () => uiController.isFullscreen.value != true
                ? const FloatPageBackButton()
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
