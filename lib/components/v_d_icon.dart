import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';

class VDIcon extends StatelessWidget {
  final VIconData? icon;
  final double? width;
  final double? height;
  const VDIcon(this.icon, {Key? key, this.width, this.height})
      : super(key: key);

  VDIcon.network(String url, {Key? key, this.width, this.height})
      : icon = VIconData(iconSvg: url, type: 'network'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: icon?.getIconWidget(),
      width: width,
      height: height,
    );
  }
}
