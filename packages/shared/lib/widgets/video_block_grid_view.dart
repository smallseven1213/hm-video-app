import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/video_block_grid_view_row.dart';

import 'base_video_preview.dart';

class VideoBlockGridView extends StatelessWidget {
  final List<Vod> videos;
  final int gridLength;
  final double? imageRatio;
  final bool isEmbeddedAds;
  final bool displayCoverVertical;
  final int? blockId;
  final bool? hasInfoView;
  final int? film;
  final bool? displayVideoCollectTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;

  const VideoBlockGridView({
    Key? key,
    required this.videos,
    this.gridLength = 2,
    this.imageRatio,
    required this.isEmbeddedAds,
    required this.displayCoverVertical,
    this.blockId,
    this.hasInfoView = true,
    this.film = 1,
    this.displayVideoCollectTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    required this.buildVideoPreview,
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
              blockId: blockId,
              hasInfoView: hasInfoView,
              film: film,
              displayVideoCollectTimes: displayVideoCollectTimes,
              displayVideoTimes: displayVideoTimes,
              displayViewTimes: displayViewTimes,
              buildVideoPreview: (video) => buildVideoPreview(video),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
