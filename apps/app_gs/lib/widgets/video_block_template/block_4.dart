import 'package:app_gs/widgets/channel_area_banner.dart';
import 'package:app_gs/widgets/video_block_footer.dart';
import 'package:app_gs/widgets/video_block_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';

final logger = Logger();

List<List<Vod>> organizeRowData(List videos, Blocks block) {
  List<List<Vod>> result = [];
  int blockQuantity = block.quantity ?? 0;

  for (int i = 0; i < blockQuantity;) {
    if (i != 0 && i == videos.length - 1) break;
    bool hasAreaAd = videos[i].dataType == VideoType.areaAd.index;
    try {
      if (hasAreaAd) {
        result.add([videos[i]]);
        i++;
      } else if (i + 2 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1], videos[i + 2]]);
        i += 3;
        // logger.i('Block1Widget 有3筆: $i');
      } else if (i + 1 < videos.length) {
        // 影片列表
        result.add([videos[i], videos[i + 1], Vod(0, '')]);
        i += 2;
        // logger.i('Block1Widget 有2筆: $i');
      } else {
        // 落單的一筆
        if (i < videos.length) {
          result.add([videos[i], Vod(0, ''), Vod(0, '')]);
          i++;
          // logger.i('Block1Widget 落單的一筆: $i');
        } else {
          break;
        }
      }
    } catch (e) {
      logger.i('err: $e');
    }
  }
  return result;
}

// 六小
class Block4Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;

  const Block4Widget({
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
                      : VideoBlockGridView(
                          blockId: block.id ?? 0,
                          videos: result[index],
                          gridLength: 3,
                          imageRatio: BlockImageRatio.block4.ratio,
                          isEmbeddedAds: block.isEmbeddedAds ?? false,
                          displayCoverVertical: true,
                          hasInfoView: false,
                          film: 2,
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
