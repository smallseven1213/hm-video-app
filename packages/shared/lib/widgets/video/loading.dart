import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/sid_image.dart';

final logger = Logger();

class VideoLoading extends StatelessWidget {
  final String coverHorizontal;
  final Image? image;
  final Widget? dotLineAnimation;
  const VideoLoading({Key? key, required this.coverHorizontal, this.image, this.dotLineAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Center(child: FlashLoading()),
            if (image != null) image!, 
            if (dotLineAnimation != null) dotLineAnimation!,  
            const SizedBox(height: 15),
            const Text(
              '精彩即將呈現',
              style: TextStyle(fontSize: 12, color: Colors.white),
            )
          ],
        ),
        const FloatPageBackButton(),
      ],
    );
  }
}
