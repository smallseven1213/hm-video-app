import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_menu_collection.dart';
import 'package:wgp_video_h5app/styles.dart';

class CMenuBarEarly extends VBaseMenuCollection {
  final List<VMenuBarItem> collection = const [
    VMenuBarItem(
      title: '首頁',
      uri: '/home',
      icon: VIcons.home_default,
      activeIcon: VIcons.home_active,
      color: color5,
      activeColor: color2,
    ),
    VMenuBarItem(
      title: '原創',
      uri: '/layout/2',
      icon: VIcons.story_default,
      activeIcon: VIcons.story_active,
      color: color5,
      activeColor: color2,
    ),
     VMenuBarItem(
       title: '動態',
       uri: '/story',
       icon: VIcons.footer_story_default,
       activeIcon: VIcons.footer_story_active,
       color: color5,
       activeColor: color2,
//       innerPage: true,
     ),
    VMenuBarItem(
      title: 'VIP',
      uri: '/member/vip2',
      icon: VIcons.footer_vip_default,
      activeIcon: VIcons.footer_vip_active,
      color: color5,
      activeColor: color2,
      // innerPage: true,
    ),
    VMenuBarItem(
      title: '發現',
      uri: '/member/ads',
      icon: VIcons.game_default,
      activeIcon: VIcons.game_active,
      color: color5,
      activeColor: color2,
//      innerPage: true,
    ),
    VMenuBarItem(
      title: '我的',
      uri: '/member',
      icon: VIcons.member_default,
      activeIcon: VIcons.member_active,
      color: color5,
      activeColor: color2,
    ),
  ];

  @override
  Map<int, VMenuBarItem> getItems() {
    // TODO: implement getItems
    return collection.asMap();
  }
}
