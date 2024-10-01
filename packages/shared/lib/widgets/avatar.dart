import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class AvatarWidget extends StatelessWidget {
  final double width;
  final double height;
  final String? photoSid;
  final Color? backgroundColor;
  final String? emptyAvatarAsset;

  const AvatarWidget({
    Key? key,
    this.photoSid,
    this.width = 60,
    this.height = 60,
    this.backgroundColor,
    this.emptyAvatarAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color firstColor = backgroundColor ?? const Color(0xFF00b2ff);
    final HSLColor hslColor = HSLColor.fromColor(firstColor);
    final HSLColor lighterHslColor =
        hslColor.withLightness((hslColor.lightness + 0.3).clamp(0.0, 1.0));
    final Color secondColor = lighterHslColor.toColor();

    return Container(
      padding: const EdgeInsets.all(1),
      width: width,
      height: height,
      decoration: kIsWeb
          ? BoxDecoration(shape: BoxShape.circle, color: firstColor)
          : BoxDecoration(
              shape: BoxShape.circle,
              gradient: backgroundColor == null
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        firstColor,
                        secondColor,
                        firstColor,
                      ],
                    )
                  : null,
              color: backgroundColor,
            ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: photoSid != null && photoSid != ''
            ? SidImage(
                key: ValueKey(photoSid),
                sid: photoSid!,
                fit: BoxFit.cover,
                width: width,
                height: height,
              )
            : Container(
                width: width,
                height: height,
                color: const Color(0xfff0f0f0),
                child: Center(
                  child: Icon(
                    Icons.face_3,
                    size: width * 0.8,
                    color: const Color(0xfff3a0a9),
                  ),
                ),
              ),
      ),
    );
  }
}
