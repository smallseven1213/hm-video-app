import 'package:app_gs/widgets/channel_area_banner.dart';
import 'package:app_gs/widgets/video_block_footer.dart';
import 'package:app_gs/widgets/video_block_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/index.dart';

List<List<Vod>> organizeRowData(List videos, Blocks block) {
  List<List<Vod>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int blockLength = 7;

  for (int i = 0; i < blockQuantity;) {
    if (i != 0 && i == videos.length - 1) break;

    bool hasAreaAd =
        block.isAreaAds == true ? i % blockLength == blockLength - 1 : false;

    try {
      if (hasAreaAd) {
        result.add([videos[i]]);
        i++;
      } else if (i + 2 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1], videos[i + 2]]);
        i += 3;
        // print('Block1Widget 有3筆: $i');
      } else if (i + 1 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1], Vod(0, '')]);
        i += 2;
        // print('Block1Widget 有2筆: $i');
      } else {
        // 落單的一筆
        if (i < videos.length) {
          result.add([videos[i], Vod(0, ''), Vod(0, '')]);
          i++;
          // print('Block1Widget 落單的一筆: $i');
        } else {
          break;
        }
      }
    } catch (e) {
      print('err: $e');
    }
  }
  return result;
}

// 六小
class Block4Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;

  const Block4Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Vod> videos = block.videos?.data ?? [];
    List<List<Vod>> result = organizeRowData(videos, block);

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index < result.length) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  child: block.isAreaAds == true && index % 3 == 2
                      ? ChannelAreaBanner(
                          image: BannerPhoto.fromJson({
                            'id': result[index][0].id ?? 0,
                            'url': result[index][0].adUrl ?? '',
                            'photoSid': result[index][0].coverVertical ?? '',
                            'isAutoClose': false,
                          }),
                        )
                      : VideoBlockGridView(
                          videos: result[index],
                          gridLength: 3,
                          imageRatio: BlockImageRatio.block4.ratio,
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
