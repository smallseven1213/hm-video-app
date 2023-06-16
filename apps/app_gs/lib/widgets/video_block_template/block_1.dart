import 'package:app_gs/widgets/channel_area_banner.dart';
import 'package:app_gs/widgets/video_block_footer.dart';
import 'package:app_gs/widgets/video_block_grid_view_row.dart';
import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';

final logger = Logger();

List<List<Vod>> organizeRowData(List<Vod> videos, Blocks block) {
  List<List<Vod>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int blockLength = block.isAreaAds == true ? 6 : 5;
  int videoLength =
      videos.length > blockQuantity ? blockQuantity : videos.length;

  try {
    for (int i = 0; i < videoLength;) {
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
        // logger.i('Block1Widget 有兩筆: $i');
      } else {
        // 落單的一筆
        result.add([videos[i]]);
        i++;
      }
    }
  } catch (e) {
    logger.i('Block1Widget error: $e');
    return [];
  }

  return result;
}

// 一大多小
class Block1Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;

  const Block1Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
    required this.film,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vod> videos = block.videos?.data ?? [];
    // bool containsAreaAd = videos.any((item) => item.dataType == 3);
    List<List<Vod>> result = organizeRowData(videos, block);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: index % 4 == 0 ||
                          (block.isAreaAds == true && index % 4 == 3)
                      ? result[index][0].dataType == VideoType.areaAd.index
                          ? ChannelAreaBanner(
                              image: BannerPhoto.fromJson({
                                'id': result[index][0].id,
                                'url': result[index][0].adUrl ?? '',
                                'photoSid':
                                    result[index][0].coverHorizontal ?? '',
                                'isAutoClose': false,
                              }),
                            )
                          : VideoPreviewWidget(
                              id: result[index][0].id,
                              title: result[index][0].title,
                              tags: result[index][0].tags ?? [],
                              timeLength: result[index][0].timeLength ?? 0,
                              coverHorizontal:
                                  result[index][0].coverHorizontal ?? '',
                              coverVertical:
                                  result[index][0].coverVertical ?? '',
                              videoViewTimes:
                                  result[index][0].videoViewTimes ?? 0,
                              videoCollectTimes:
                                  result[index][0].videoCollectTimes ?? 0,
                              detail: result[index][0],
                              isEmbeddedAds: block.isEmbeddedAds ?? false,
                              displayVideoTimes: film == 1,
                              displayViewTimes: film == 1,
                              displayVideoCollectTimes: film == 2,
                            )
                      : VideoBlockGridViewRow(
                          videoData: result[index],
                          imageRatio: BlockImageRatio.block1.ratio,
                          isEmbeddedAds: block.isEmbeddedAds ?? false,
                          displayVideoTimes: film == 1,
                          displayViewTimes: film == 1,
                          displayVideoCollectTimes: film == 2,
                        ),
                ),
                if (index == result.length - 1) ...[
                  const SizedBox(height: 16),
                  VideoBlockFooter(
                    film: film,
                    block: block,
                    updateBlock: updateBlock,
                    channelId: channelId,
                  ),
                ]
              ],
            ),
          );
        },
        childCount: result.length,
      ),
    );
  }
}
