import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDButton extends StatefulWidget {
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Widget? child;
  const VDButton({
    Key? key,
    this.onTap,
    this.child,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _VDButtonState createState() => _VDButtonState();
}

class _VDButtonState extends State<VDButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.width ?? (gs().width - 20),
        height: widget.height ?? 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          top: 9,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: widget.child,
      ),
    );
  }
}
