import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/user/watch_permission_provider.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/short_video_player/index.dart';
import '../../localization/i18n.dart';
import '../../utils/show_confirm_dialog.dart';
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
        widget.toggleFullScreen(); //
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl.isEmpty) {
      return const LoadingAnimation();
    }
    return WatchPermissionProvider(
      showConfirmDialog: () {
        showConfirmDialog(
          context: context,
          message: I18n.plsLoginToWatch,
          cancelButtonText: I18n.back,
          barrierDismissible: false,
          onConfirm: () => MyRouteDelegate.of(context).push(AppRoutes.login),
          onCancel: () => MyRouteDelegate.of(context).popToHome(),
        );
      },
      child: (canWatch) => Container(
        color: Colors.black,
        child: Stack(
          children: [
            VideoPlayerProvider(
              key: Key(widget.videoUrl),
              tag: widget.videoUrl,
              autoPlay: kIsWeb ? false : canWatch,
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
              child: (isReady, controller) => ShortCard(
                key: Key(widget.tag),
                index: widget.index,
                videoUrl: widget.videoUrl,
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
                                    videoUrl: widget.videoUrl,
                                    tag: widget.tag,
                                    data: videoDetail,
                                    title: widget.title,
                                    controllerTag: widget.controllerTag ?? "",
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
            ),
            Positioned(
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
                            tag: widget.tag,
                            videoUrl: widget.videoUrl,
                            data: videoDetail,
                            title: widget.title,
                            controllerTag: widget.controllerTag ?? "",
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Obx(
              () => uiController.isFullscreen.value != true
                  ? const FloatPageBackButton()
                  : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }
}
