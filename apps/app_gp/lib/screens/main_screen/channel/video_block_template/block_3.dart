import 'package:app_gp/widgets/channel_area_banner.dart';
import 'package:app_gp/widgets/video_block_footer.dart';
import 'package:app_gp/widgets/video_block_grid_view_row.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

List<List<Data>> organizeRowData(List videos, Blocks block) {
  List<List<Data>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int blockLength = block.isAreaAds == true ? 6 : 5;

  for (int i = 0; i < blockQuantity;) {
    bool hasAreaAd =
        block.isAreaAds == true ? i % blockLength == blockLength - 1 : false;
    if (hasAreaAd) {
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

// 六小
class Block3Widget extends StatelessWidget {
  final Blocks block;
  const Block3Widget({
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  child: block.isAreaAds == true && index % 4 == 3
                      ? ChannelAreaBanner(
                          image: BannerImage.fromJson({
                            'id': result[index][0].id ?? 0,
                            'url': result[index][0].adUrl ?? '',
                            'photoSid': result[index][0].coverHorizontal ?? '',
                            'isAutoClose': false,
                          }),
                        )
                      : VideoBlockGridViewRow(
                          videoData: result[index],
                          imageRatio: 182 / 102,
                          isEmbeddedAds: block.isEmbeddedAds ?? false,
                        ),
                ),
              );
            },
          ),
          VideoBlockFooter(block: block)
        ],
      ),
    );
  }
}
