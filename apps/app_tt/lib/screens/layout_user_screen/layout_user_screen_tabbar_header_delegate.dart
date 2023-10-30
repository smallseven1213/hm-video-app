import 'package:app_tt/localization/i18n.dart';
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
              color: Color(0xFF161823),
              width: 2.0,
            ),
          ),
          tabs: [
            Tab(text: I18n.browseHistory),
            Tab(text: I18n.likePlaylist),
            Tab(text: I18n.collectPlaylist)
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
