import 'package:flutter/material.dart';
import 'package:shared/utils/video_info_formatter.dart';

class VideoCollectionTimes extends StatelessWidget {
  final int times;
  final Color? color;
  const VideoCollectionTimes({super.key, required this.times, this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: const TextStyle(
        height: 1,
      ),
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.favorite_border_rounded,
              color: color ?? Colors.white,
              size: 16,
            ),
          ),
          TextSpan(
            text:
                ' ${formatNumberToUnit(times, shouldCalculateThousands: false)}',
            style: TextStyle(
              color: color ?? Colors.white,
              letterSpacing: 0.1,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
