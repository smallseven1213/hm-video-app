import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'video_preview_skelton.dart';

class VideoPreviewSkeletonList extends StatelessWidget {
  final double imageRatio;

  const VideoPreviewSkeletonList({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      crossAxisCount: 2,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return VideoPreviewSkeleton();
      },
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 10.0,
    );
  }
}
