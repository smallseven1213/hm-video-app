import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';

import '../base/v_icon_collection.dart';
import '../helpers/getx.dart';

class VDStickyTabBarDelegate2 extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final Color? backgroundColor;
  VDStickyTabBarDelegate2({required this.child, this.backgroundColor});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0, top: 0),
      color: backgroundColor ?? Theme.of(context).backgroundColor,
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
                    InkWell(
                      onTap: () {
                        back();
                      },
                      enableFeedback: true,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 14,
                      ),
                    ),
                    SizedBox(width: a,),
                    Container(
                      width: sideWidth,
                      child: child,
                    ),
                  ],
                ),
                SizedBox(height: 10,)
              ],
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => child.preferredSize.height + 10;

  @override
  double get minExtent => child.preferredSize.height + 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
