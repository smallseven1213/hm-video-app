import 'package:app_gp/widgets/channel_area_banner.dart';
import 'package:app_gp/widgets/video_block_footer.dart';
import 'package:app_gp/widgets/video_block_grid_view_row.dart';
import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

List<List<Data>> organizeRowData(List videos, Blocks block) {
  List<List<Data>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int blockLength = block.isAreaAds == true ? 6 : 5;

  for (int i = 0; i < blockQuantity;) {
    if (i == videos.length - 1) break;
    bool hasAreaAd =
        block.isAreaAds == true ? i % blockLength == blockLength - 1 : false;

    if (i % blockLength == 0 || hasAreaAd) {
      result.add([videos[i]]);
      i++;
    } else {
      if (i + 2 > videos.length) {
        result.add([videos[i]]);
        i++;
      } else {
        result.add([videos[i], videos[i + 1]]);
        i += 2;
      }
    }
  }
  return result;
}

// 一大多小
class Block1Widget extends StatelessWidget {
  final Blocks block;
  const Block1Widget({
    Key? key,
    required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> videos = block.videos?.data ?? [];
    List<List<Data>> result = organizeRowData(videos, block);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            result.length,
            (index) {
              return Container(
                padding: const EdgeInsets.only(bottom: 8.0),
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
                        imageRatio: 182 / 102,
                        isEmbeddedAds: block.isEmbeddedAds ?? false,
                      ),
              );
            },
          ),
          VideoBlockFooter(
            block: block,
          )
        ],
      ),
    );
  }
}
