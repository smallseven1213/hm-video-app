import 'package:app_gs/widgets/video_list_loading_text.dart';
import 'package:flutter/material.dart';

class SliverVideoPreviewSkeletonList extends StatelessWidget {
  final double imageRatio;

  const SliverVideoPreviewSkeletonList({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return SliverPadding(
        padding: const EdgeInsets.only(bottom: 20),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: SizedBox(
              height: 100,
              child: VideoListLoadingText(),
            ),
          ),
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   // return SliverAlignedGrid.count(
  //   //   crossAxisCount: 2,
  //   //   itemCount: 6,
  //   //   itemBuilder: (BuildContext context, int index) {
  //   //     return VideoPreviewSkeleton();
  //   //   },
  //   //   mainAxisSpacing: 12.0,
  //   //   crossAxisSpacing: 10.0,
  //   // );
  //   return const SliverToBoxAdapter(
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: 60),
  //       child: Center(
  //         child: Text(
  //           '更多影片讀取中...',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
