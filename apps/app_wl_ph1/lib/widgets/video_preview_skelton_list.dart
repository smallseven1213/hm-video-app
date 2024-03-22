import 'package:app_gs/localization/i18n.dart';
import 'package:flutter/material.dart';

class VideoPreviewSkeletonList extends StatelessWidget {
  final double imageRatio;

  const VideoPreviewSkeletonList({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return AlignedGridView.count(
    //   crossAxisCount: 2,
    //   itemCount: 6,
    //   itemBuilder: (BuildContext context, int index) {
    //     return VideoPreviewSkeleton();
    //   },
    //   mainAxisSpacing: 12.0,
    //   crossAxisSpacing: 10.0,
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Text(
          I18n.moreVideosLoading,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
