import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/video_collection_times.dart';
import 'package:shared/widgets/view_times.dart';
import 'package:shared/widgets/video_time.dart';
import 'package:shared/widgets/visibility_detector.dart';

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
            : const BorderRadius.vertical(bottom: Radius.circular(10)),
        gradient: kIsWeb
            ? null
            : LinearGradient(
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

class VideoPreviewWidget extends StatelessWidget {
  final int id;
  final String coverVertical;
  final String coverHorizontal;
  final bool displayCoverVertical;
  final int timeLength;
  final List<Tag> tags;
  final String title;
  final int? videoViewTimes;
  final int? videoCollectTimes;
  final double? imageRatio;
  final Vod? detail;
  final bool isEmbeddedAds;
  final bool? hasTags;
  final bool? hasInfoView;
  final int? film; // 1長視頻, 2短視頻, 3漫畫
  final int? blockId;
  final bool? hasRadius; // 要不要圓角
  final bool? hasTitle; // 要不要標題
  final bool? hasTapEvent; // 要不要點擊事件
  final bool? displayVideoCollectTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;
  final Function()? onTap;
  final Function(int id)? onOverrideRedirectTap; // 自定義路由轉址

  const VideoPreviewWidget({
    Key? key,
    required this.id,
    required this.coverVertical,
    required this.coverHorizontal,
    this.displayCoverVertical = false,
    required this.timeLength,
    required this.tags,
    required this.title,
    this.videoViewTimes = 0,
    this.videoCollectTimes = 0,
    this.isEmbeddedAds = false,
    this.detail,
    this.imageRatio,
    this.film = 1,
    this.hasTags = true,
    this.hasInfoView = true,
    this.blockId,
    this.hasRadius = true,
    this.hasTitle = true,
    this.onTap,
    this.hasTapEvent = true,
    this.onOverrideRedirectTap,
    this.displayVideoCollectTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // logger.i('RENDER VIDEO PREVIEW WIDGET!!!');
    if (detail?.dataType == VideoType.embeddedAd.index && isEmbeddedAds) {
      return VideoEmbeddedAdWidget(
        imageRatio: imageRatio ?? 374 / 198,
        detail: detail!,
        displayCoverVertical: displayCoverVertical,
      );
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
            if (hasTapEvent == true) {
              if (onOverrideRedirectTap != null) {
                onOverrideRedirectTap!(id);
              } else {
                if (film == 1) {
                  MyRouteDelegate.of(context).push(
                    AppRoutes.video,
                    args: {'id': id, 'blockId': blockId},
                    removeSamePath: true,
                  );
                } else if (film == 2) {
                  MyRouteDelegate.of(context).push(
                    AppRoutes.shortsByBlock,
                    args: {'videoId': id, 'areaId': blockId},
                  );
                } else if (film == 3) {
                  // MyRouteDelegate.of(context).push(
                  //   AppRoutes.comic.value,
                  //   args: {'id': id, 'blockId': blockId},
                  //   removeSamePath: true,
                  // );
                }
              }
            }
          },
          child: Stack(
            children: [
              // 背景
              AspectRatio(
                aspectRatio: imageRatio ??
                    (displayCoverVertical == true ? 119 / 179 : 374 / 198),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: hasRadius == true
                            ? const BorderRadius.all(Radius.circular(10))
                            : null,
                        color: const Color(0xFF00234D)
                        // color: Colors.white,
                        ),
                    clipBehavior: Clip.antiAlias,
                    child: const Center(
                      child: Image(
                        image: AssetImage(
                            'assets/images/video_preview_loading.png'),
                        width: 102,
                        height: 70,
                      ),
                    )),
              ),
              // 主體
              AspectRatio(
                aspectRatio: imageRatio ??
                    (displayCoverVertical == true ? 119 / 179 : 374 / 198),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: hasRadius == true
                          ? const BorderRadius.all(Radius.circular(10))
                          : null,
                      // color: Colors.white,
                    ),
                    foregroundDecoration: BoxDecoration(
                      gradient: kIsWeb
                          ? null
                          : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.3),
                              ],
                              stops: const [0.9, 1.0],
                            ),
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
                    child: ViewInfo(
                        videoCollectTimes: videoCollectTimes,
                        viewCount: videoViewTimes ?? 0,
                        duration: timeLength,
                        displayVideoTimes: displayVideoTimes,
                        displayViewTimes: displayViewTimes,
                        displayVideoCollectTimes: displayVideoCollectTimes)),
            ],
          ),
        ),
        const SizedBox(height: 5),
        if (hasTitle == true)
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
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
                              args: {'id': tag.id, 'title': tag.name},
                              removeSamePath: true,
                            );
                          } else if (film == 2) {
                            MyRouteDelegate.of(context).push(
                                AppRoutes.supplierTag,
                                args: {'tagId': tag.id, 'tagName': tag.name});
                          } else if (film == 3) {}
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: const Color(0xff21488E),
                                borderRadius: kIsWeb
                                    ? BorderRadius.zero
                                    : BorderRadius.circular(10)),
                            child: Text(
                              '${kIsWeb ? '#' : ''}${tag.name}',
                              style: const TextStyle(
                                color: Color(0xff21AFFF),
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
    );
  }
}
