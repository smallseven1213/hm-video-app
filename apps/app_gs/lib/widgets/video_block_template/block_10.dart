import 'package:app_gs/widgets/channel_area_banner.dart';
import 'package:app_gs/widgets/video_block_footer.dart';
import 'package:app_gs/widgets/video_block_grid_view_row.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';

List<List<Vod>> organizeRowData(List videos, Blocks block) {
  List<List<Vod>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int videoLength =
      videos.length > blockQuantity ? blockQuantity : videos.length;

  try {
    for (int i = 0; i < videoLength;) {
      if (i != 0 && i == videos.length) break;
      bool hasAreaAd = videos[i].dataType == VideoType.areaAd.index;
      if (hasAreaAd) {
        // 廣告那一筆
        result.add([videos[i]]);
        // logger.i('Block1Widget 廣告變成一筆: $i');
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

// 六直
class Block10Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;
  const Block10Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
    required this.film,
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
                  child: result[index][0].dataType == VideoType.areaAd.index
                      ? ChannelAreaBanner(
                          image: BannerPhoto.fromJson({
                            'id': result[index][0].id,
                            'url': result[index][0].adUrl ?? '',
                            'photoSid': result[index][0].coverHorizontal ?? '',
                            'isAutoClose': false,
                          }),
                        )
                      : VideoBlockGridViewRow(
                          videoData: result[index],
                          imageRatio: BlockImageRatio.block10.ratio,
                          isEmbeddedAds: block.isEmbeddedAds ?? false,
                          displayCoverVertical: true,
                          blockId: block.id ?? 0,
                          film: film,
                          displayVideoCollectTimes: false,
                          displayVideoTimes: true,
                          displayViewTimes: true,
                        ),
                ),
              );
            } else {
              return VideoBlockFooter(
                  film: film,
                  block: block,
                  updateBlock: updateBlock,
                  channelId: channelId);
            }
          },
          childCount: result.length + 1,
        ),
      ),
    );
  }
}
