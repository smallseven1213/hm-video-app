import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/sid_image.dart';

import '../config/colors.dart';

class CircleTextItem extends StatelessWidget {
  final String text;
  final double imageWidth;
  final double imageHeight;
  final bool isRounded;
  final bool hasBorder;
  final String photoSid;
  final Function()? onTap;

  const CircleTextItem({
    Key? key,
    required this.text,
    this.imageWidth = 60,
    this.imageHeight = 60,
    this.isRounded = true,
    this.hasBorder = true,
    required this.photoSid,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: imageWidth,
        height: imageHeight,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: kIsWeb
            ? BoxDecoration(
                borderRadius: isRounded
                    ? BorderRadius.circular(40)
                    : BorderRadius.circular(5),
                color: AppColors.colors[ColorKeys.jingangBorder],
              )
            : BoxDecoration(
                borderRadius: isRounded
                    ? BorderRadius.circular(40)
                    : BorderRadius.circular(5),
                color: hasBorder
                    ? isRounded
                        ? AppColors.colors[ColorKeys.jingangBorder]
                        : AppColors.colors[ColorKeys.primary]
                    : null,
              ),
        child: Container(
            margin: isRounded ? const EdgeInsets.all(1) : null,
            decoration: BoxDecoration(
              borderRadius: isRounded
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(5),
            ),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              onTap: onTap,
              child: SidImage(
                key: ValueKey(photoSid),
                sid: photoSid,
              ),
            )),
      ),
      Text(text,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.colors[ColorKeys.textPrimary],
          )),
    ]);
  }
}
