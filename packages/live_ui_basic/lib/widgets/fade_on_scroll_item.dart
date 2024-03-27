import 'package:flutter/material.dart';

class FadeOnScrollItem extends StatelessWidget {
  final Widget child;
  final double topPosition;
  final ScrollController scrollController;

  const FadeOnScrollItem({
    Key? key,
    required this.child,
    required this.topPosition,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([scrollController]),
      builder: (context, child) {
        final viewportHeight = scrollController.position.viewportDimension;
        final offset = scrollController.offset;
        double opacity = 1.0;

        // 由於列表是反向的，我們需要根據距離底部的位置計算透明度
        double distanceFromBottom = viewportHeight - (topPosition - offset);

        // 當項目進入視覺底部（列表的頂部）的50px範圍內時，調整透明度
        if (distanceFromBottom > 0 && distanceFromBottom <= 50) {
          opacity = distanceFromBottom / 50;
        } else if (distanceFromBottom <= 0) {
          opacity = 0.0;
        }

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: child,
        );
      },
      child: child,
    );
  }
}
