import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../../config/colors.dart';
import 'flash_loading.dart';

final logger = Logger();

class VideoLoading extends StatelessWidget {
  final String coverHorizontal;
  const VideoLoading({Key? key, required this.coverHorizontal})
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
                      AppColors.colors[ColorKeys.primary]!,
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
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: FlashLoading()),
            SizedBox(height: 15),
            Text(
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
