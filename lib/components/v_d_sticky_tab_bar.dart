import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_tab_collection.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';
import 'package:wgp_video_h5app/components/v_d_tab_bar.dart';
import 'package:wgp_video_h5app/styles.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;

class VDStickyTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;
  final int currentIndex;
  final int tabBarType;
  final VTabCollection controller;
  final bool? showExtra;
  final int layoutId;
  final GestureTapCallback? onOpenCustomChannels;
  final double? overrideTabHeight;

  const VDStickyTabBar({
    Key? key,
    required this.tabController,
    required this.currentIndex,
    required this.controller,
    this.showExtra = false,
    this.tabBarType = 1,
    this.layoutId = 1,
    this.onOpenCustomChannels,
    this.overrideTabHeight = _kTabHeight,
  }) : super(key: key);

  @override
  _VDStickyTabBarState createState() => _VDStickyTabBarState();

  @override
  Size get preferredSize {
    double maxHeight = (overrideTabHeight ?? 0) + 2;
    return Size.fromHeight(maxHeight);
  }
}

class _VDStickyTabBarState extends State<VDStickyTabBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Expanded(
              flex: 7,
              child: VDTabBar(
                tabController: widget.tabController,
                index: widget.currentIndex,
                tabs: widget.controller,
                type: widget.tabBarType,
              ),
            ),
            widget.tabBarType == 1 && widget.showExtra == true
                ? Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: widget
                          .onOpenCustomChannels, // () {gto('/channel-settings/${widget.layoutId}');},
                      child: Container(
                        height: 48,
                        decoration: const BoxDecoration(
                          color: color1,
                          // boxShadow: [
                          //   BoxShadow(
                          //     spreadRadius: 2,
                          //     blurRadius: 3,
                          //     offset: Offset(-1, -3.5),
                          //     color: Colors.black38,
                          //   ),
                          // ],
                        ),
                        padding: const EdgeInsets.only(top: 14, bottom: 12),
                        child: const VDIcon(VIcons.classification),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ],
    );
  }
}
