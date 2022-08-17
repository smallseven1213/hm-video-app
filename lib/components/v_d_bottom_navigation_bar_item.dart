import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';

class VDBottomNavigationBarItem extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Widget? icon;
  final VIconData? iconData;
  final VIconData? activeIconData;
  final Widget? label;
  final String text;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;

  const VDBottomNavigationBarItem({
    Key? key,
    required this.onTap,
    required this.isActive,
    this.icon,
    this.label,
    this.iconData,
    this.activeIconData,
    this.text = '',
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: InkWell(
        onTap: Feedback.wrapForTap(onTap, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 32,
              child: icon ??
                  VDIcon(
                    isActive ? activeIconData : iconData,
                    // color: isActive ? activeColor : inactiveColor,
                  ),
            ),
            label ??
                Text(
                  text,
                  style: TextStyle(
                    color: isActive ? activeColor : inactiveColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
