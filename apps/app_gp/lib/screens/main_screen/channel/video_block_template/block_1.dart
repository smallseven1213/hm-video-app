import 'package:app_gp/widgets/video_block_grid_view_row.dart';
import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

List<List<Data>> organizeRowData(List videos, Blocks block) {
  List<List<Data>> result = [];
  int blockQuantity = block.quantity ?? 0;
  int blockLength = block.isAreaAds == true ? 6 : 5;

  for (int i = 0; i < blockQuantity;) {
    if (i % blockLength == 0 || i % blockLength == 5) {
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
  Blocks block;
  Block1Widget({
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
        children: List.generate(
          result.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                child: index % 4 == 0 || index % 4 == 3
                    ? VideoPreviewWidget(
                        title: result[index][0].title ?? '',
                        tags: result[index][0].tags ?? [],
                        timeLength: result[index][0].timeLength ?? 0,
                        coverHorizontal: result[index][0].coverHorizontal ?? '',
                        coverVertical: result[index][0].coverVertical ?? '',
                        videoViewTimes: result[index][0].videoViewTimes ?? 0,
                        imageRatio: 374 / 198,
                      )
                    : VideoBlockGridViewRow(videoData: result[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
