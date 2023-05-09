import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/vod.dart';

import 'video_block_grid_view_row.dart';

final logger = Logger();

class VideoBlockGridView extends StatelessWidget {
  final List<Vod> videos;
  final int gridLength;
  final double? imageRatio;
  final bool isEmbeddedAds;
  final bool displayCoverVertical;

  const VideoBlockGridView({
    Key? key,
    required this.videos,
    this.gridLength = 2,
    this.imageRatio,
    required this.isEmbeddedAds,
    required this.displayCoverVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (videos.length / gridLength).ceil(),
      itemBuilder: (context, index) {
        int start = index * gridLength;
        int end = (start + gridLength <= videos.length)
            ? start + gridLength
            : videos.length;
        List<Vod> rowData = videos.sublist(start, end);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VideoBlockGridViewRow(
              videoData: rowData,
              gridLength: gridLength,
              imageRatio: imageRatio,
              isEmbeddedAds: isEmbeddedAds,
              displayCoverVertical: displayCoverVertical,
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
