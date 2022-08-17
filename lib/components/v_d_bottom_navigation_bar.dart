import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_menu_collection.dart';
import 'package:wgp_video_h5app/components/v_d_bottom_navigation_bar_item.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../configs/c_menu_bar_dark.dart';

class VDBottomNavigationBar extends StatefulWidget {
  final Function? onTap;
  final int activeIndex;
  final VBaseMenuCollection collection;
  const VDBottomNavigationBar({
    Key? key,
    required this.activeIndex,
    required this.onTap,
    required this.collection,
  }) : super(key: key);

  @override
  _VDBottomNavigationBarState createState() => _VDBottomNavigationBarState();
}

class _VDBottomNavigationBarState extends State<VDBottomNavigationBar> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _activeIndex = widget.activeIndex;
  }

  void tapping(String name, int index) {
    widget.onTap!(name, index);
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = widget.collection is CMenuBarDark;
    return Material(
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: navigationBarBackgroundColor,
          border: Border(
            top: BorderSide(
              color: isDark ? Color(0xff222222): navigationBarBackgroundColor,
              width: navigationBarBorderWidth,
            ),
          ),
        ),
        child: Material(
          color: isDark ? Color(0xff181818): Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.collection
                .getItems()
                .map(
                  (idx, e) => MapEntry(
                    idx,
                    VDBottomNavigationBarItem(
                      isActive: _activeIndex == idx,
                      onTap: () {
                        if (e.innerPage) {
                          gto(e.uri);
                        } else {
                          tapping(e.uri, idx);
                        }
                      },
                      iconData: e.icon,
                      activeIconData: e.activeIcon,
                      text: e.title,
                      activeColor: e.activeColor,
                      inactiveColor: e.color,
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}
