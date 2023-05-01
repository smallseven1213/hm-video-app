import 'package:app_gs/widgets/channel_area_banner.dart';
import 'package:app_gs/widgets/video_block_footer.dart';
import 'package:app_gs/widgets/video_block_grid_view_row.dart';
import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

Map<String, dynamic> organizeRowDataForSliverDelegate(
    List<Data> videos, Blocks block, Function updateBlock, int channelId) {
  List<List<Data>> result = [];
  List<Widget> rowWidgets = [];
  int blockQuantity = block.quantity ?? 0;
  int blockLength = block.isAreaAds == true ? 6 : 5;
  try {
    for (int i = 0; i < blockQuantity;) {
      if (i != 0 && i == videos.length) break;
      bool hasAreaAd =
          block.isAreaAds == true ? i % blockLength == blockLength - 1 : false;

      if (i % blockLength == 0 || hasAreaAd) {
        result.add([videos[i]]);
        i++;
      } else if (i + 1 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1]]);
        i += 2;
      } else {
        // 落單的一筆
        result.add([videos[i]]);
        i++;
      }
    }

    for (int index = 0; index < result.length; index++) {
      rowWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: index % 4 == 0 ||
                        (block.isAreaAds == true && index % 4 == 3)
                    ? result[index][0].dataType == VideoType.areaAd.index
                        ? ChannelAreaBanner(
                            image: BannerImage.fromJson({
                              'id': result[index][0].id ?? 0,
                              'url': result[index][0].adUrl ?? '',
                              'photoSid':
                                  result[index][0].coverHorizontal ?? '',
                              'isAutoClose': false,
                            }),
                          )
                        : VideoPreviewWidget(
                            id: result[index][0].id!,
                            title: result[index][0].title ?? '',
                            tags: result[index][0].tags ?? [],
                            timeLength: result[index][0].timeLength ?? 0,
                            coverHorizontal:
                                result[index][0].coverHorizontal ?? '',
                            coverVertical: result[index][0].coverVertical ?? '',
                            videoViewTimes:
                                result[index][0].videoViewTimes ?? 0,
                            detail: result[index][0],
                            isEmbeddedAds: block.isEmbeddedAds ?? false,
                          )
                    : VideoBlockGridViewRow(
                        videoData: result[index],
                        imageRatio: BlockImageRatio.block1.ratio,
                        isEmbeddedAds: block.isEmbeddedAds ?? false,
                      ),
              ),
              if (index == result.length - 1) ...[
                const SizedBox(height: 16),
                VideoBlockFooter(
                  block: block,
                  updateBlock: updateBlock,
                  channelId: channelId,
                ),
              ]
            ],
          ),
        ),
      );
    }
  } catch (e) {
    print('Block1Widget error: $e');
    return {'count': 0, 'children': []};
  }

  return {'count': result.length, 'children': rowWidgets};
}
