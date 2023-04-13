import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'video_preview_skelton.dart';

class SliverVideoPreviewSkeletonList extends StatelessWidget {
  final double imageRatio;

  const SliverVideoPreviewSkeletonList({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAlignedGrid.count(
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
