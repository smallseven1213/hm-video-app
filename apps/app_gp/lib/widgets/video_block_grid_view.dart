import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/channel_info.dart';

import 'video_block_grid_view_row.dart';

final logger = Logger();

class VideoBlockGridView extends StatelessWidget {
  final List<Data> videos;
  const VideoBlockGridView({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (videos.length / 2).ceil(),
      itemBuilder: (context, index) {
        int start = index * 2;
        int end = (start + 2 <= videos.length) ? start + 2 : videos.length;
        List<Data> rowData = videos.sublist(start, end);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VideoBlockGridViewRow(videoData: rowData),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
