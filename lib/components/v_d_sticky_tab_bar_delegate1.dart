import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';
import 'package:wgp_video_h5app/helpers/index.dart';

import '../base/v_icon_collection.dart';

class VDStickyTabBarDelegate1 extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final Color? backgroundColor;
  final Widget? iconLeft;
  final Widget? iconRight;
  VDStickyTabBarDelegate1({required this.child, this.backgroundColor, this.iconLeft, this.iconRight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0, top: 0),
      color: backgroundColor,
      child: LayoutBuilder(
        builder: (_cc, BoxConstraints constraints) {
          var centerwidth = constraints.maxWidth - 32 - 44;
          var sideWidth = centerwidth / 1.69;
          var a = (centerwidth - sideWidth) / 2;
          return Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 16,),
                    iconLeft ?? Container(
                      width: 22,
                    ),
                    // SizedBox(width: a,),
                    Container(
                      width: gs().width -76,
                      alignment: Alignment.center,
                      child: child,
                    ),
                    // SizedBox(width: a,),
                    // Spacer(),
                    iconRight ?? Container(
                      width: 22,
                    ),
                    SizedBox(width: 16,),
                  ],
                ),
                // SizedBox(height: 10,)
              ],
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
