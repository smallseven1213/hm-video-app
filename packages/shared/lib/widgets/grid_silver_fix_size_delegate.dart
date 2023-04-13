import 'package:flutter/rendering.dart';

class SliverGridDelegateWithFixedSize extends SliverGridDelegate {
  final double height;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  SliverGridDelegateWithFixedSize(this.height,
      {this.mainAxisSpacing = 0.0, this.crossAxisSpacing = 0.0});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final crossAxisCount = 2;
    final crossAxisSpacing = this.crossAxisSpacing;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: height + mainAxisSpacing,
      crossAxisStride: constraints.crossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: height,
      childCrossAxisExtent: constraints.crossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithFixedSize oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing;
  }
}
