import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/base_video_preview.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/video_collection_times.dart';
import 'package:shared/widgets/video/view_times.dart';
import 'package:shared/widgets/video/video_time.dart';
import 'package:shared/widgets/visibility_detector.dart';

class ViewInfo extends StatelessWidget {
  final int viewCount;
  final int duration;
  final int? videoFavoriteTimes;
  final bool? displayVideoFavoriteTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;

  const ViewInfo({
    Key? key,
    required this.viewCount,
    required this.duration,
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

class ChannelVideoPreviewWidget extends BaseVideoPreviewWidget {
  const ChannelVideoPreviewWidget({
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
                            I18n.username,
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
                          child: Row(
                            children: [
                              const Image(
                                  width: 17,
                                  height: 17,
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/video_preview_hot_icon.png')),
                              const SizedBox(width: 8),
                              Text(
                                videoViewTimes.toString(),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: const TextStyle(
                                  color: Color(0xFF6B6B6B),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ))
                    ],
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
