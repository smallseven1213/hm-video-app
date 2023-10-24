// VideoPlayerArea stateful widget
import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/sid_image.dart';

import 'dot_line_animation.dart';

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
                      const Color.fromARGB(255, 0, 34, 79),
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
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Image(
            image: AssetImage('assets/images/logo.png'),
            width: 60.0,
          ),
          const DotLineAnimation(),
          const SizedBox(height: 15),
          Text(
            I18n.comingSoon,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          )
        ]),
        const FloatPageBackButton(),
      ],
    );
  }
}
