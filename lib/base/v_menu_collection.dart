import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';

class VMenuBarItem {
  final String title;
  final String uri;
  final VIconData icon;
  final VIconData activeIcon;
  final Color color;
  final Color activeColor;
  final bool innerPage;
  const VMenuBarItem({
    required this.title,
    required this.uri,
    required this.icon,
    required this.activeIcon,
    required this.color,
    required this.activeColor,
    this.innerPage = false,
  });
}

abstract class VBaseMenuCollection {
  // late List<VMenuBarItem> collection;
  Map<int, VMenuBarItem> getItems();
}
