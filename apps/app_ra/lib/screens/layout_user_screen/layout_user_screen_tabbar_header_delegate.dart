import 'package:flutter/material.dart';

import '../../widgets/ra_tab_bar.dart';

class LayoutUserScreenTabBarHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  LayoutUserScreenTabBarHeaderDelegate(this.tabController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return RATabBar(
      controller: tabController,
      tabs: const ['我的足跡', '我的喜歡', '我的收藏'],
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(
      covariant LayoutUserScreenTabBarHeaderDelegate oldDelegate) {
    return false;
  }
}
