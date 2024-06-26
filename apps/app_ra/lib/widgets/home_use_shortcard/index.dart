import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/widgets/short_video_player/index.dart';
import '../../utils/show_confirm_dialog.dart';
import '../shortcard/short_card_info.dart';
import '../wave_loading.dart';

class HomeUseShortCard extends StatefulWidget {
  final int index;
  final String tag;
  final int id;
  final String title;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;
  final String videoUrl;

  const HomeUseShortCard({
    Key? key,
    required this.index,
    required this.tag,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    required this.videoUrl,
    // required this.isFullscreen,
    this.isActive = true,
    this.displayFavoriteAndCollectCount = true,
  }) : super(key: key);

  @override
  HomeUseShortCardState createState() => HomeUseShortCardState();
}

class HomeUseShortCardState extends State<HomeUseShortCard> {
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
      return const WaveLoading();
    }

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          VideoPlayerProvider(
            key: Key(widget.videoUrl),
            tag: widget.tag,
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
            loadingWidget: const WaveLoading(),
            child: (isReady, controller) => ShortCard(
              key: Key(widget.tag),
              index: widget.index,
              tag: widget.tag,
              isActive: widget.isActive,
              id: widget.shortData.id,
              title: widget.shortData.title,
              shortData: widget.shortData,
              toggleFullScreen: widget.toggleFullScreen,
              allowFullsreen: true,
              showConfirmDialog: showConfirmDialog,
              showProgressBar: false,
            ),
          ),
          Positioned(
            bottom: -8,
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
                          tag: widget.tag,
                          data: videoDetail,
                          title: widget.title,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
