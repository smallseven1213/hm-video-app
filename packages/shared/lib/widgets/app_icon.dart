import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class AppIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final String logoSid;

  const AppIcon({
    Key? key,
    required this.logoSid,
    this.width = 46,
    this.height = 46,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: height,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        child: SidImage(
          sid: logoSid,
          height: width ?? 47,
          width: height ?? 47,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
