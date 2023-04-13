import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VideoPreviewSkeleton extends StatelessWidget {
  final double imageRatio;

  VideoPreviewSkeleton({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.2),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: imageRatio,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: 100,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
