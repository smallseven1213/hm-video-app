import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/base_video_preview.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/video_collection_times.dart';
import 'package:shared/widgets/video/view_times.dart';
import 'package:shared/widgets/video/video_time.dart';
import 'package:shared/widgets/visibility_detector.dart';

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
    bool? displayVideoCollectTimes = true,
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
    // if (detail?.dataType == VideoType.embeddedAd.index && isEmbeddedAds) {
    //   return VideoEmbeddedAdWidget(
    //     imageRatio: imageRatio ?? 374 / 198,
    //     detail: detail!,
    //     displayCoverVertical: displayCoverVertical,
    //   );
    // }

    return GestureDetector(
      onTap: () => super.onVideoTap(context),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // 影片封面
            AspectRatio(
              aspectRatio: imageRatio ??
                  (displayCoverVertical == true ? 119 / 179 : 374 / 198),
              child: Stack(
                children: [
                  SidImage(
                    key: ValueKey('video-preview-$id'),
                    sid: displayCoverVertical ? coverVertical : coverHorizontal,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black87,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // in children: left is play button and flex 1 , right is video time and width by content
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 30,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Image(
                                      width: 15,
                                      height: 17,
                                      image: AssetImage(
                                          'assets/images/play_count.webp'),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      videoViewTimes.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 5),
                              child: VideoTime(time: timeLength),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        color: Color(0xFF161823),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Row(
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
                                child: Text(
                                  '${kIsWeb ? '#' : ''}${tag.name}',
                                  style: const TextStyle(
                                    color: Color(0xFF73747b),
                                    fontSize: 10,
                                    height: 1.4,
                                  ),
                                )),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
