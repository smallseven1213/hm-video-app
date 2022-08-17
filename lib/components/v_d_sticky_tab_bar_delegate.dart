import 'package:flutter/material.dart';

class VDStickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final Color? backgroundColor;
  VDStickyTabBarDelegate({required this.child, this.backgroundColor});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor ?? Theme.of(context).backgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
