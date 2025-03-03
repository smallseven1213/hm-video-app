import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VideoPreviewSkeleton extends StatelessWidget {
  final double imageRatio;

  const VideoPreviewSkeleton({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF003068),
      highlightColor: const Color(0xFF00234d),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: imageRatio,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 12,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 100,
            height: 20,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
