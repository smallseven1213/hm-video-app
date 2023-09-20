// write a stateless widget
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool? isCircle;

  const ShimmerWidget({
    Key? key,
    required this.width,
    required this.height,
    this.isCircle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: isCircle == true
            ? const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              )
            : BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
      ),
    );
  }
}
