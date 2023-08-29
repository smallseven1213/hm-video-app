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
              child: SidImageVisibilityDetector(
                child: SidImage(
                  key: ValueKey('video-preview-$id'),
                  sid: displayCoverVertical ? coverVertical : coverHorizontal,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '用戶名稱',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(
                              color: Color(0xFF6B6B6B),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          videoViewTimes.toString(),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                            color: Color(0xFF6B6B6B),
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

    // return Container(
    // decoration: const BoxDecoration(
    //   borderRadius: BorderRadius.all(Radius.circular(4)),
    // ),
    //   child: Column(
    //     children: [
    //       GestureDetector(
    //         onTap: () => super.onVideoTap(context),
    //         child: Stack(children: [
    //           // 背景
    //           // AspectRatio(
    //           //   aspectRatio: imageRatio ??
    //           //       (displayCoverVertical == true ? 119 / 179 : 374 / 198),
    //           //   child: Container(
    //           //       decoration: BoxDecoration(
    //           //           borderRadius: hasRadius == true
    //           //               ? const BorderRadius.all(Radius.circular(10))
    //           //               : null,
    //           //           color: const Color(0xFF00234D)
    //           //           // color: Colors.white,
    //           //           ),
    //           //       clipBehavior: Clip.antiAlias,
    //           //       child: const Center(
    //           //         child: Image(
    //           //           image:
    //           //               AssetImage('assets/images/video_preview_loading.png'),
    //           //           width: 102,
    //           //           height: 70,
    //           //         ),
    //           //       )),
    //           // ),
    //           // 主體
    // AspectRatio(
    //   aspectRatio: imageRatio ??
    //       (displayCoverVertical == true ? 119 / 179 : 374 / 198),
    //   child: Container(
    //       decoration: BoxDecoration(
    //         borderRadius: hasRadius == true
    //             ? const BorderRadius.all(Radius.circular(10))
    //             : null,
    //         // color: Colors.white,
    //       ),
    //       foregroundDecoration: BoxDecoration(
    //         gradient: kIsWeb
    //             ? null
    //             : LinearGradient(
    //                 begin: Alignment.topCenter,
    //                 end: Alignment.bottomCenter,
    //                 colors: [
    //                   Colors.black.withOpacity(0.0),
    //                   Colors.black.withOpacity(0.3),
    //                 ],
    //                 stops: const [0.9, 1.0],
    //               ),
    //       ),
    //       clipBehavior: Clip.antiAlias,
    //       child: SidImageVisibilityDetector(
    //         child: SidImage(
    //           key: ValueKey('video-preview-$id'),
    //           sid: displayCoverVertical
    //               ? coverVertical
    //               : coverHorizontal,
    //           width: double.infinity,
    //           fit: BoxFit.cover,
    //         ),
    //       )),
    // ),
    //           if (hasInfoView == true)
    //             Positioned(
    //                 left: 0,
    //                 right: 0,
    //                 bottom: 0,
    //                 child: ViewInfo(
    //                     videoCollectTimes: videoCollectTimes,
    //                     viewCount: videoViewTimes ?? 0,
    //                     duration: timeLength,
    //                     displayVideoTimes: displayVideoTimes,
    //                     displayViewTimes: displayViewTimes,
    //                     displayVideoCollectTimes: displayVideoCollectTimes)),
    //         ]),
    //       ),
    //       const SizedBox(height: 5),
    //       if (hasTitle == true)
    // Container(
    //   alignment: Alignment.centerLeft,
    // child: Text(
    //   title,
    //   textAlign: TextAlign.left,
    //   overflow: TextOverflow.ellipsis,
    //   softWrap: false,
    //   style: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 12,
    //   ),
    // ),
    // ),
    //       if (tags.isNotEmpty && hasTags == true) ...[
    //         const SizedBox(height: 5),
    //         Align(
    //           alignment: Alignment.centerLeft,
    //           child: Container(
    //             height: 20,
    //             decoration: kIsWeb
    //                 ? null
    //                 : BoxDecoration(
    //                     borderRadius: BorderRadius.circular(10),
    //                   ),
    //             clipBehavior: kIsWeb ? Clip.none : Clip.antiAlias,
    //             child: Wrap(
    //               crossAxisAlignment: WrapCrossAlignment.start,
    //               spacing: 5.0,
    //               runSpacing: 5.0,
    //               clipBehavior: Clip.antiAlias,
    //               children: tags
    //                   .take(3)
    //                   .map(
    //                     (tag) => GestureDetector(
    //                       onTap: () {
    //                         if (film == 1) {
    //                           MyRouteDelegate.of(context).push(
    //                             AppRoutes.tag,
    //                             args: {'id': tag.id, 'title': tag.name},
    //                             removeSamePath: true,
    //                           );
    //                         } else if (film == 2) {
    //                           MyRouteDelegate.of(context).push(
    //                               AppRoutes.supplierTag,
    //                               args: {'tagId': tag.id, 'tagName': tag.name});
    //                         } else if (film == 3) {}
    //                       },
    //                       child: Container(
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 8, vertical: 2),
    //                           decoration: BoxDecoration(
    //                               color: const Color(0xff21488E),
    //                               borderRadius: kIsWeb
    //                                   ? BorderRadius.zero
    //                                   : BorderRadius.circular(10)),
    //                           child: Text(
    //                             '${kIsWeb ? '#' : ''}${tag.name}',
    //                             style: const TextStyle(
    //                               color: Color(0xff21AFFF),
    //                               fontSize: 10,
    //                               height: 1.4,
    //                             ),
    //                           )),
    //                     ),
    //                   )
    //                   .toList(),
    //             ),
    //           ),
    //         )
    //       ]
    //       // The rest of your UI logic
    //       // ...
    //     ],
    //   ),
    // );
  }
}
