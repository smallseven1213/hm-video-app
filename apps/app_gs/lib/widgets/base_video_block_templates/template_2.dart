import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/vod.dart';

import '../channel_area_banner.dart';
import '../video_preview.dart';

SliverChildBuilderDelegate baseVideoBlockTemplate2({
  required List<Vod> vods,
  required int areaId,
  int? film = 1,
}) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      var video = vods[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: video.dataType == VideoType.areaAd.index
            ? ChannelAreaBanner(
                image: BannerPhoto.fromJson({
                  'id': video.id,
                  'url': video.adUrl ?? '',
                  'photoSid': video.coverHorizontal ?? '',
                  'isAutoClose': false,
                }),
              )
            : VideoPreviewWidget(
                id: video.id,
                title: video.title,
                tags: video.tags ?? [],
                timeLength: video.timeLength ?? 0,
                coverHorizontal: video.coverHorizontal ?? '',
                coverVertical: video.coverVertical ?? '',
                videoViewTimes: video.videoViewTimes ?? 0,
                videoCollectTimes: video.videoCollectTimes ?? 0,
                detail: video,
                isEmbeddedAds: true,
                blockId: areaId,
                film: film,
              ),
      );
    },
    childCount: vods.length,
  );
}
