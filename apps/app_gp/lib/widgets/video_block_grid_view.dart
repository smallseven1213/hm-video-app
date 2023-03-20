import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/channel_info.dart';

import 'video_block_grid_view_row.dart';

final logger = Logger();

class VideoBlockGridView extends StatelessWidget {
  final List<Data> videos;
  final int gridLength;
  const VideoBlockGridView({
    Key? key,
    required this.videos,
    this.gridLength = 2,
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
        List<Data> rowData = videos.sublist(start, end);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VideoBlockGridViewRow(videoData: rowData, gridLength: gridLength),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
