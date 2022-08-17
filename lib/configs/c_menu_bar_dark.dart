import 'dart:ui';

import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_menu_collection.dart';
import 'package:wgp_video_h5app/styles.dart';

class CMenuBarDark extends VBaseMenuCollection {
  final List<VMenuBarItem> collection = const [
    VMenuBarItem(
      title: '首頁',
      uri: '/home',
      icon: VIcons.footer_home_default_white,
      activeIcon: VIcons.footer_home_active_dark,
      color: color5,
      activeColor: mainBgColor,
    ),
    VMenuBarItem(
      title: '動態',
      uri: '/story',
      icon: VIcons.footer_story_default_white,
      activeIcon: VIcons.footer_story_active_dark,
      color: color5,
      activeColor: mainBgColor,
    ),
    VMenuBarItem(
      title: '發現',
      uri: '/layout/2',
      icon: VIcons.footer_story_default_white,
      activeIcon: VIcons.footer_story_active_dark,
      color: color5,
      activeColor: mainBgColor,
    ),
    VMenuBarItem(
      title: '應用中心',
      uri: '/member/ads',
      icon: VIcons.footer_game_default_white,
      activeIcon: VIcons.footer_game_active_dark,
      color: color5,
      activeColor: mainBgColor,
    ),
    VMenuBarItem(
      title: '我的',
      uri: '/member',
      icon: VIcons.footer_member_default_white,
      activeIcon: VIcons.footer_member_active_dark,
      color: color5,
      activeColor: mainBgColor,
    ),
  ];


  @override
  Map<int, VMenuBarItem> getItems() {
    // TODO: implement getItems
    return collection.asMap();
  }
}
