import 'package:app_gp/widgets/channel_area_banner.dart';
import 'package:app_gp/widgets/video_block_footer.dart';
import 'package:app_gp/widgets/video_block_grid_view_row.dart';
import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

List<List<Data>> organizeRowData(List<Data> videos, Blocks block) {
  List<List<Data>> result = [];
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
        // print('Block1Widget 有兩筆: $i');
      } else {
        // 落單的一筆
        result.add([videos[i]]);
        i++;
      }
    }
  } catch (e) {
    print('Block1Widget error: $e');
    return [];
  }

  return result;
}

// 一大多小
class Block1Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  const Block1Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> videos = block.videos?.data ?? [];
    List<List<Data>> result = organizeRowData(videos, block);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                              coverVertical:
                                  result[index][0].coverVertical ?? '',
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
          );
        },
        childCount: result.length,
      ),
    );
  }
}
