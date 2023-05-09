import 'package:app_gs/widgets/channel_area_banner.dart';
import 'package:app_gs/widgets/video_block_footer.dart';
import 'package:app_gs/widgets/video_block_grid_view_row.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/index.dart';

List<List<Data>> organizeRowData(List videos, Blocks block) {
  List<List<Data>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int blockLength = 7;
  try {
    for (int i = 0; i < blockQuantity;) {
      if (i != 0 && i == videos.length) break;
      bool hasAreaAd =
          block.isAreaAds == true ? i % blockLength == blockLength - 1 : false;
      if (hasAreaAd) {
        // 廣告那一筆
        result.add([videos[i]]);
        // print('Block1Widget 廣告變成一筆: $i');
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

// 六直
class Block10Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  const Block10Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> videos = block.videos?.data ?? [];
    List<List<Data>> result = organizeRowData(videos, block);

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index < result.length) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  child: block.isAreaAds == true && index % 4 == 3
                      ? ChannelAreaBanner(
                          image: BannerPhoto.fromJson({
                            'id': result[index][0].id ?? 0,
                            'url': result[index][0].adUrl ?? '',
                            'photoSid': result[index][0].coverVertical ?? '',
                            'isAutoClose': false,
                          }),
                        )
                      : VideoBlockGridViewRow(
                          videoData: result[index],
                          imageRatio: BlockImageRatio.block10.ratio,
                          isEmbeddedAds: block.isEmbeddedAds ?? false,
                          displayCoverVertical: true,
                        ),
                ),
              );
            } else {
              return VideoBlockFooter(
                  block: block, updateBlock: updateBlock, channelId: channelId);
            }
          },
          childCount: result.length + 1,
        ),
      ),
    );
  }
}
