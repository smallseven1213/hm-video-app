import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/sid_image.dart';
import '../../../localization/shared_localization_delegate.dart';

final logger = Logger();

class VideoLoading extends StatelessWidget {
  final String coverHorizontal;
  final Image? image;
  final Widget? loadingAnimation;
  final bool? isPost;
  final double? width; 
  final double? height; 

  const VideoLoading({
    Key? key,
    required this.coverHorizontal,
    this.image,
    this.loadingAnimation,
    this.isPost = false,
    this.width, 
    this.height, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
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
            width: width ?? double.infinity, // 設置寬度
            height: height ?? double.infinity, // 設置高度
            fit: BoxFit.cover,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null) Center(child: image!),
            if (loadingAnimation != null) Center(child: loadingAnimation!),
            const SizedBox(height: 15),
            Center(
              child: Text(
                localizations.translate('coming_soon'),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
        if (!isPost!) const FloatPageBackButton(),
      ],
    );
  }
}
