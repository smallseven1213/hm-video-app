import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/widgets/short_video_player/purchase/coin_part.dart';
import 'package:shared/widgets/short_video_player/draggable_video_progress_bar.dart';
import 'package:shared/widgets/short_video_player/error.dart';
import 'package:shared/widgets/short_video_player/fullscreen_controls.dart';
import 'package:shared/widgets/short_video_player/player.dart';
import 'package:video_player/video_player.dart';
import 'purchase_promotion.dart';
import 'purchase/vip_part.dart';
import 'short_video_mute_button.dart';
import 'side_info.dart';

class ShortCard extends StatefulWidget {
  final String tag;
  final int index;
  final int id;
  final String title;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;
  final bool allowFullsreen;
  final Widget Function(int timeLength)? vipPartBuilder;
  final Widget Function({
    required String buyPoints,
    required int videoId,
    required VideoPlayerInfo videoPlayerInfo,
    required int timeLength,
    required Function() onSuccess,
  })? coinPartBuilder;
  final Function showConfirmDialog;
  final bool? showProgressBar;
  final String videoUrl;

  const ShortCard({
    Key? key,
    required this.tag,
    required this.videoUrl,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    required this.allowFullsreen,
    required this.showConfirmDialog,
    // required this.isFullscreen,
    this.isActive = true,
    this.displayFavoriteAndCollectCount = true,
    this.vipPartBuilder,
    this.coinPartBuilder,
    this.showProgressBar = true,
  }) : super(key: key);

  @override
  ShortCardState createState() => ShortCardState();
}

class ShortCardState extends State<ShortCard> {
  final UIController uiController = Get.find<UIController>();
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    var paddingBottom =
        uiController.isIphoneSafari.value ? 20 : screen.padding.bottom;

    return VideoPlayerConsumer(
      tag: widget.videoUrl,
      child: (VideoPlayerInfo videoPlayerInfo) {
        if (videoPlayerInfo.videoPlayerController == null) {
          return Container();
        }
        if (uiController.isFullscreen.value == true) {
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
                toggleFullScreen: widget.toggleFullScreen,
              ),
              if (videoPlayerInfo
                      .observableVideoPlayerController.videoAction.value ==
                  'error')
                ShortVideoConsumer(
                  vodId: widget.id,
                  tag: widget.tag,
                  child: ({
                    required isLoading,
                    required video,
                    required videoDetail,
                    required videoUrl,
                  }) =>
                      VideoError(
                          videoCover: video!.coverVertical ?? '',
                          errorMessage: videoPlayerInfo
                              .observableVideoPlayerController
                              .errorMessage
                              .value,
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
                height: screen.size.height - 76 - paddingBottom,
                width: double.infinity,
                child: ShortVideoConsumer(
                  vodId: widget.id,
                  tag: widget.tag,
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
                      widget.toggleFullScreen();
                    },
                  ),
                ),
              ),
              if (widget.showProgressBar == true)
                Positioned(
                  bottom: -16,
                  left: 0,
                  right: 0,
                  child: DraggableVideoProgressBar(
                    videoPlayerController: videoPlayerInfo
                        .observableVideoPlayerController.videoPlayerController!,
                  ),
                ),
              ShortVideoConsumer(
                vodId: widget.id,
                tag: widget.tag,
                child: ({
                  required isLoading,
                  required video,
                  required videoDetail,
                  required videoUrl,
                }) =>
                    video?.isAvailable == false &&
                            videoPlayerInfo.videoAction == 'end'
                        ? Positioned.fill(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.4),
                              child: PurchasePromotion(
                                tag: widget.tag,
                                buyPoints: video!.buyPoint.toString(),
                                timeLength: video.timeLength ?? 0,
                                chargeType: video.chargeType ?? 0,
                                videoId: video.id,
                                videoPlayerInfo: videoPlayerInfo,
                                vipPartBuilder: widget.vipPartBuilder ??
                                    (int timeLength) =>
                                        VipPart(timeLength: timeLength),
                                coinPartBuilder: widget.coinPartBuilder ??
                                    ({
                                      required String buyPoints,
                                      required int videoId,
                                      required VideoPlayerInfo videoPlayerInfo,
                                      required int timeLength,
                                      required Function() onSuccess,
                                      userPoints,
                                    }) =>
                                        CoinPart(
                                          tag: widget.tag,
                                          buyPoints: buyPoints,
                                          videoId: videoId,
                                          videoPlayerInfo: videoPlayerInfo,
                                          timeLength: timeLength,
                                          showConfirmDialog:
                                              widget.showConfirmDialog,
                                        ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
              Obx(
                () => uiController.isFullscreen.value == true
                    ? const SizedBox.shrink()
                    : ShortVideoConsumer(
                        vodId: widget.id,
                        tag: widget.tag,
                        child: ({
                          required isLoading,
                          required video,
                          required videoDetail,
                          required videoUrl,
                        }) =>
                            SideInfo(
                          tag: widget.tag,
                          videoId: widget.shortData.id,
                          shortData: widget.shortData,
                          videoUrl: videoUrl ?? '',
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
