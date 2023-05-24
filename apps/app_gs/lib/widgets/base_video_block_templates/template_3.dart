import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/block_image_ratio.dart';
import 'package:shared/models/vod.dart';

import '../channel_area_banner.dart';
import '../video_block_grid_view_row.dart';

List<List<Vod>> organizeRowData(List videos) {
  List<List<Vod>> resultArray = [];
  List<Vod> tempArray = [];

  for (int i = 0; i < videos.length; i++) {
    tempArray.add(videos[i]);
    bool hasAreaAd = videos[i].dataType == VideoType.areaAd.index;

    if (hasAreaAd) {
      resultArray.add(tempArray);
      tempArray = [];
    } else if (tempArray.length == 2) {
      resultArray.add(tempArray);
      tempArray = [];
    }
  }

  if (tempArray.isNotEmpty) {
    resultArray.add(tempArray);
  }

  return resultArray;
}

SliverChildBuilderDelegate baseVideoBlockTemplate3({
  required List<Vod> vods,
}) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      // 每2個vods組成一個videos
      List<List<Vod>> result = organizeRowData(vods);
      return Padding(
        // padding bottom 8
        padding: const EdgeInsets.only(bottom: 8.0),
        child: result[index][0].dataType == VideoType.areaAd.index
            ? ChannelAreaBanner(
                image: BannerPhoto.fromJson({
                  'id': result[index][0].id ?? 0,
                  'url': result[index][0].adUrl ?? '',
                  'photoSid': result[index][0].coverHorizontal ?? '',
                  'isAutoClose': false,
                }),
              )
            : VideoBlockGridViewRow(
                videoData: result[index],
                gridLength: 2,
                imageRatio: BlockImageRatio.block3.ratio,
                isEmbeddedAds: true,
              ),
      );
    },
    childCount: organizeRowData(vods).length,
  );
}
