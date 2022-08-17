import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_menu_collection.dart';
import 'package:wgp_video_h5app/styles.dart';

class CMenuBar extends VBaseMenuCollection {
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
      title: '動態',
      uri: '/store',
      icon: VIcons.story_default,
      activeIcon: VIcons.story_active,
      color: color5,
      activeColor: color2,
    ),
    VMenuBarItem(
      title: '遊戲',
      uri: '/game',
      icon: VIcons.game_default,
      activeIcon: VIcons.game_active,
      color: color5,
      activeColor: color2,
    ),
    VMenuBarItem(
      title: '直播',
      uri: '/live',
      icon: VIcons.live_default,
      activeIcon: VIcons.live_active,
      color: color5,
      activeColor: color2,
    ),
    VMenuBarItem(
      title: '社群',
      uri: '/community',
      icon: VIcons.community_default,
      activeIcon: VIcons.community_active,
      color: color5,
      activeColor: color2,
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
