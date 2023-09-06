import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class VideoCover extends StatelessWidget {
  final String coverHorizontal;
  const VideoCover({
    Key? key,
    required this.coverHorizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SidImage(
          key: ValueKey(coverHorizontal),
          sid: coverHorizontal,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // sigma值控制模糊程度
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }
}
