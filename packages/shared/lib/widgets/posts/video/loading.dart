import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/sid_image.dart';
import '../../../localization/shared_localization_delegate.dart';

final logger = Logger();

class VideoLoading extends StatelessWidget {
  final String coverHorizontal;
  final Image? image;
  final Widget? loadingAnimation;
  final double? width;
  final double? height;

  const VideoLoading({
    Key? key,
    required this.coverHorizontal,
    this.image,
    this.loadingAnimation,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return Stack(
      alignment: Alignment.center, // 设置 Stack 的对齐方式为居中

      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            gradient: kIsWeb
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.white.withOpacity(1),
                    ],
                    stops: const [0.8, 1.0],
                  ),
          ),
          child: SidImage(
            key: ValueKey(coverHorizontal),
            sid: coverHorizontal,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null) Center(child: image!),
            if (loadingAnimation != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Center(child: loadingAnimation!),
              ),
            Center(
              child: Text(
                localizations.translate('coming_soon'),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
