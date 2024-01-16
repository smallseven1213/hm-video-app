import 'package:flutter/material.dart';

import 'video_list_loading_text.dart';

class SliverVideoPreviewSkeletonList extends StatelessWidget {
  final double imageRatio;

  const SliverVideoPreviewSkeletonList({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return SliverPadding(
        padding: const EdgeInsets.only(bottom: 20),
        sliver: const SliverToBoxAdapter(
          child: Center(
            child: SizedBox(
              height: 100,
              child: VideoListLoadingText(),
            ),
          ),
        ));
  }
}
