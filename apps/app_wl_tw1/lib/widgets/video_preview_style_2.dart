import 'package:app_wl_tw1/config/colors.dart';
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

import 'video_embedded_ad.dart';

class ViewInfo extends StatelessWidget {
  final int viewCount;
  final int duration;
  final bool hasRadius;
  final int? videoFavoriteTimes;
  final bool? displayVideoFavoriteTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;

  const ViewInfo({
    Key? key,
    required this.viewCount,
    required this.duration,
    required this.hasRadius,
    this.displayVideoFavoriteTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.videoFavoriteTimes,
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

    if (displayVideoFavoriteTimes == true) {
      infoItems.add(VideoCollectionTimes(times: videoFavoriteTimes ?? 0));
    }

    if (infoItems.isEmpty) {
      return Container();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: hasRadius
            ? const BorderRadius.vertical(
                bottom: Radius.circular(10),
              )
            : null,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.05, 1.0],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: infoItems,
      ),
    );
  }
}

class VideoPreviewStyle2Widget extends BaseVideoPreviewWidget {
  const VideoPreviewStyle2Widget({
    Key? key,
    required int id,
    required String coverVertical,
    required String coverHorizontal,
    bool displayCoverVertical = false,
    required int timeLength,
    required List<Tag> tags,
    required String title,
    int? videoViewTimes = 0,
    int? videoFavoriteTimes = 0,
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
    bool? displayVideoFavoriteTimes = true,
    bool? displayVideoTimes = true,
    bool? displayViewTimes = true,
    bool displayPublisher = false,
    String? publisherName,
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
          videoFavoriteTimes: videoFavoriteTimes,
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
          displayVideoFavoriteTimes: displayVideoFavoriteTimes,
          displayVideoTimes: displayVideoTimes,
          displayViewTimes: displayViewTimes,
          displayPublisher: displayPublisher,
          publisherName: publisherName,
        );

  @override
  Widget build(BuildContext context) {
    if (detail?.dataType == VideoType.embeddedAd.index && isEmbeddedAds) {
      return VideoEmbeddedAdWidget(
        imageRatio: imageRatio ??
            (displayCoverVertical == true ? 119 / 179 : 374 / 198),
        detail: detail!,
        displayCoverVertical: displayCoverVertical,
      );
    }

    return Column(
      children: [
        GestureDetector(
            onTap: () => super.onVideoTap(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(children: [
                    // 背景
                    AspectRatio(
                      aspectRatio: imageRatio ??
                          (displayCoverVertical == true
                              ? 119 / 179
                              : 374 / 198),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: hasRadius == true
                              ? const BorderRadius.all(Radius.circular(10))
                              : null,
                          color: AppColors.colors[ColorKeys.videoPreviewBg],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: const Center(
                          child: Image(
                            image: AssetImage(
                                'assets/images/video_preview_loading.png'),
                            width: 102,
                            height: 70,
                          ),
                        ),
                      ),
                    ),
                    // 主體
                    AspectRatio(
                      aspectRatio: imageRatio ??
                          (displayCoverVertical == true
                              ? 119 / 179
                              : 374 / 198),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: hasRadius == true
                                ? const BorderRadius.all(Radius.circular(10))
                                : null,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SidImageVisibilityDetector(
                            child: SidImage(
                              key: ValueKey('video-preview-$id'),
                              sid: displayCoverVertical
                                  ? coverVertical
                                  : coverHorizontal,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    if (hasInfoView == true)
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.vertical(
                                bottom: hasTitle == true
                                    ? const Radius.circular(10)
                                    : Radius.zero,
                              ),
                            ),
                            child: ViewInfo(
                              videoFavoriteTimes: videoFavoriteTimes,
                              viewCount: videoViewTimes ?? 0,
                              duration: timeLength,
                              displayVideoTimes: displayVideoTimes,
                              displayViewTimes: displayViewTimes,
                              displayVideoFavoriteTimes:
                                  displayVideoFavoriteTimes,
                              hasRadius: hasTitle == true,
                            ),
                          )),
                  ]),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasTitle == true)
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: false,
                          style: TextStyle(
                            color: AppColors.colors[ColorKeys.textPrimary],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    if (displayPublisher == true)
                      Text(
                        publisherName!,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: const TextStyle(
                          color: Color(0xFF6B6B6B),
                          fontSize: 12,
                        ),
                      ),
                    if (tags.isNotEmpty && hasTags == true) ...[
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 20,
                          decoration: kIsWeb
                              ? null
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                          clipBehavior: kIsWeb ? Clip.none : Clip.antiAlias,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 5.0,
                            runSpacing: 5.0,
                            clipBehavior: Clip.antiAlias,
                            children: tags
                                .take(3)
                                .map(
                                  (tag) => GestureDetector(
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
                                            .push(AppRoutes.supplierTag, args: {
                                          'tagId': tag.id,
                                          'tagName': tag.name
                                        });
                                      } else if (film == 3) {}
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: AppColors.colors[
                                                ColorKeys.buttonBgSecondary],
                                            borderRadius: kIsWeb
                                                ? BorderRadius.zero
                                                : BorderRadius.circular(10)),
                                        child: Text(
                                          '${kIsWeb ? '#' : ''}${tag.name}',
                                          style: TextStyle(
                                            color: AppColors.colors[
                                                ColorKeys.textSecondary],
                                            fontSize: 10,
                                            height: 1.4,
                                          ),
                                        )),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    ]
                  ],
                ))
              ],
            )),
      ],
    );
  }
}
