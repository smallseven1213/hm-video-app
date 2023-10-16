import 'package:flutter/material.dart';

import '../../widgets/tt_tab_bar.dart';

class LayoutUserScreenTabBarHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  LayoutUserScreenTabBarHeaderDelegate(this.tabController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 60,
      color: Colors.white,
      child: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: const Color(0xFF73747b),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Color(0xFF161823), // 这里是你想要的颜色
              width: 2.0, // 这是下划线的宽度，可以根据需要进行调整
            ),
          ),
          tabs: const [
            Tab(text: '我的足跡'),
            Tab(text: '我的喜歡'),
            Tab(text: '我的收藏')
          ]),
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
