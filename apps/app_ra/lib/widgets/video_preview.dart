import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/base_video_preview.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/video_collection_times.dart';
import 'package:shared/widgets/video/view_times.dart';
import 'package:shared/widgets/video/video_time.dart';
import 'package:shared/widgets/visibility_detector.dart';

import '../config/colors.dart';
import '../screens/search/tag_item.dart';
import 'video_embedded_ad.dart';

class ViewInfo extends StatelessWidget {
  final int viewCount;
  final int duration;
  final int? videoCollectTimes;
  final bool? displayVideoCollectTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;

  const ViewInfo({
    Key? key,
    required this.viewCount,
    required this.duration,
    this.displayVideoCollectTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.videoCollectTimes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> infoItems = [];

    if (displayViewTimes == true) {
      infoItems.add(ViewTimes(times: viewCount));
    }

    if (displayVideoTimes == true) {
      infoItems.add(VideoTime(time: duration));
    }

    if (displayVideoCollectTimes == true) {
      infoItems.add(VideoCollectionTimes(times: videoCollectTimes ?? 0));
    }

    if (infoItems.isEmpty) {
      return Container();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: kIsWeb
            ? null
            : const BorderRadius.vertical(bottom: Radius.circular(4)),
        color: Colors.black.withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: infoItems,
      ),
    );
  }
}

class VideoPreviewWidget extends BaseVideoPreviewWidget {
  VideoPreviewWidget({
    Key? key,
    required int id,
    required String coverVertical,
    required String coverHorizontal,
    bool displayCoverVertical = false,
    required int timeLength,
    required List<Tag> tags,
    required String title,
    int? videoViewTimes = 0,
    int? videoCollectTimes = 0,
    bool isEmbeddedAds = false,
    Vod? detail,
    double? imageRatio,
    int? film = 1,
    bool? hasTags = true,
    bool? hasInfoView = true,
    int? blockId,
    bool? hasRadius = true,
    bool? hasTitle = true,
    Function()? onTap,
    bool? hasTapEvent = true,
    Function(int id)? onOverrideRedirectTap,
    bool? displayVideoCollectTimes = false,
    bool? displayVideoTimes = true,
    bool? displayViewTimes = true,
    bool? displaySupplier = true,
  }) : super(
          key: key,
          id: id,
          coverVertical: coverVertical,
          coverHorizontal: coverHorizontal,
          displayCoverVertical: displayCoverVertical,
          timeLength: timeLength,
          tags: tags,
          title: title,
          videoViewTimes: videoViewTimes,
          videoCollectTimes: videoCollectTimes,
          isEmbeddedAds: isEmbeddedAds,
          detail: detail,
          imageRatio: imageRatio,
          film: film,
          hasTags: hasTags,
          hasInfoView: hasInfoView,
          blockId: blockId,
          hasRadius: hasRadius,
          hasTitle: hasTitle,
          onTap: onTap,
          hasTapEvent: hasTapEvent,
          onOverrideRedirectTap: onOverrideRedirectTap,
          displayVideoCollectTimes: displayVideoCollectTimes,
          displayVideoTimes: displayVideoTimes,
          displayViewTimes: displayViewTimes,
          displaySupplier: displaySupplier,
        );

  @override
  Widget build(BuildContext context) {
    double defaultImageRatio =
        imageRatio ?? (displayCoverVertical == true ? 119 / 179 : 374 / 198);

    if (detail?.dataType == VideoType.embeddedAd.index && isEmbeddedAds) {
      return VideoEmbeddedAdWidget(
        imageRatio: defaultImageRatio,
        detail: detail!,
        displayCoverVertical: displayCoverVertical,
      );
    }

    return GestureDetector(
        onTap: () => super.onVideoTap(context),
        child: Column(children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: defaultImageRatio,
                  child: SidImageVisibilityDetector(
                    child: SidImage(
                      key: ValueKey('video-preview-$id'),
                      sid: displayCoverVertical
                          ? coverVertical
                          : coverHorizontal,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (hasInfoView == true)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ViewInfo(
                      videoCollectTimes: videoCollectTimes,
                      viewCount: videoViewTimes ?? 0,
                      duration: timeLength,
                      displayVideoTimes: displayVideoTimes,
                      displayViewTimes: displayViewTimes,
                      displayVideoCollectTimes: displayVideoCollectTimes,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                // 標題
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      color: AppColors.colors[ColorKeys.videoTitle]!,
                      fontSize: 16,
                    ),
                  ),
                ),
                // tags
                if (tags.isNotEmpty && hasTags == true)
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 18,
                          child: Wrap(
                            spacing: 5.0,
                            alignment: WrapAlignment.center,
                            runSpacing: 5.0,
                            clipBehavior: Clip.antiAlias,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: tags
                                .take(3)
                                .map(
                                  (tag) => TagItem(
                                    tag: '#${tag.name}',
                                    onTap: () {
                                      if (film == 1) {
                                        MyRouteDelegate.of(context).push(
                                          AppRoutes.tag,
                                          args: {
                                            'id': tag.id,
                                            'title': tag.name
                                          },
                                          removeSamePath: true,
                                        );
                                      } else if (film == 2) {
                                        MyRouteDelegate.of(context)
                                            .push(AppRoutes.tag, args: {
                                          'id': tag.id,
                                          'title': tag.name,
                                          'defaultTabIndex': 1,
                                        });
                                      } else if (film == 3) {}
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )),
              ],
            ),
          )
        ]));
  }
}


// 