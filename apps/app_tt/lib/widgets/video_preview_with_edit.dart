import 'package:app_tt/widgets/short_video_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/video/view_times.dart';
import 'package:shared/widgets/video/video_time.dart';

import 'video_embedded_ad.dart';
import 'video_preview.dart';

const gridRatio = 128 / 227;

class ViewInfo extends StatelessWidget {
  final int viewCount;
  final int duration;

  const ViewInfo({Key? key, required this.viewCount, required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: kIsWeb
          ? null
          : BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.05, 1.0],
              ),
              // color: Colors.black.withOpacity(0.5),
            ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ViewTimes(times: viewCount),
          VideoTime(time: duration),
        ],
      ),
    );
  }
}

class VideoPreviewWithEditWidget extends StatelessWidget {
  final int id;
  final String coverVertical;
  final String coverHorizontal;
  final bool displayCoverVertical;
  final int timeLength;
  final List<Tag> tags;
  final String title;
  final int videoViewTimes;
  final int videoFavoriteTimes;
  final double? imageRatio;
  final Vod? detail;
  final bool isEmbeddedAds;
  final bool isEditing;
  final bool isSelected;
  final Function()? onEditingTap;
  final Function()? onTap;
  final bool? noTags;
  final bool? noInfoView;
  final int? film; // 1長視頻, 2短視頻, 3漫畫
  final int? blockId;
  final bool? hasRadius; // 要不要圓角
  final bool? hasTitle; // 要不要標題
  final bool? hasTags;
  final bool? displayVideoFavoriteTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;
  final Function(int id)? onOverrideRedirectTap; // 自定義路由轉址

  const VideoPreviewWithEditWidget(
      {Key? key,
      required this.id,
      required this.coverVertical,
      required this.coverHorizontal,
      this.displayCoverVertical = false,
      required this.timeLength,
      required this.tags,
      required this.title,
      required this.videoViewTimes,
      this.videoFavoriteTimes = 0,
      this.isEmbeddedAds = false,
      this.detail,
      this.isEditing = false,
      this.isSelected = false,
      this.imageRatio,
      this.onEditingTap,
      this.onTap,
      this.film = 1,
      this.noTags = false,
      this.noInfoView = false,
      this.blockId,
      this.hasRadius = true,
      this.hasTitle = true,
      this.hasTags = true,
      this.displayVideoFavoriteTimes = true,
      this.displayVideoTimes = true,
      this.displayViewTimes = true,
      this.onOverrideRedirectTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (detail?.dataType == VideoType.embeddedAd.index && isEmbeddedAds) {
      return VideoEmbeddedAdWidget(
        imageRatio: imageRatio ?? 374 / 198,
        detail: detail!,
      );
    }
    return Stack(
      children: [
        film == 1
            ? VideoPreviewWidget(
                id: id,
                film: film,
                hasTags: hasTags,
                hasTitle: hasTitle,
                displayCoverVertical: displayCoverVertical,
                coverVertical: coverVertical,
                coverHorizontal: coverHorizontal,
                imageRatio: imageRatio,
                timeLength: timeLength,
                tags: tags,
                title: title,
                hasRadius: hasRadius,
                videoViewTimes: videoViewTimes,
                videoFavoriteTimes: videoFavoriteTimes,
                hasTapEvent: !isEditing,
                displayVideoTimes: displayVideoTimes,
                displayViewTimes: displayViewTimes,
                displayVideoFavoriteTimes: displayVideoFavoriteTimes,
                onOverrideRedirectTap: onOverrideRedirectTap)
            : ShortVideoPreviewWidget(
                id: id,
                displayCoverVertical: true,
                film: film,
                coverVertical: coverVertical,
                coverHorizontal: coverHorizontal,
                timeLength: timeLength,
                tags: tags,
                imageRatio: 128 / 173,
                title: title,
                hasTags: hasTags,
                hasTitle: hasTitle,
                hasRadius: hasRadius,
                videoViewTimes: videoViewTimes,
                videoFavoriteTimes: videoFavoriteTimes,
                hasTapEvent: !isEditing,
                displayVideoTimes: displayVideoTimes,
                displayViewTimes: displayViewTimes,
                displayVideoFavoriteTimes: displayVideoFavoriteTimes,
                onOverrideRedirectTap: onOverrideRedirectTap,
              ),
        if (isEditing)
          Positioned.fill(
            child: GestureDetector(
              onTap: onEditingTap,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        if (isEditing)
          Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 20,
                height: 20,
                // 半透明背景，黑色0.5
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isSelected
                    ? const Image(
                        image: AssetImage('assets/images/check_yes.png'),
                        width: 20,
                        height: 20,
                      )
                    : null,
              )),
      ],
    );
  }
}
