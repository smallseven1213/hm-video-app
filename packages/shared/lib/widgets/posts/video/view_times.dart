import 'package:flutter/material.dart';
import 'package:shared/utils/video_info_formatter.dart';

class ViewTimes extends StatelessWidget {
  final int times;
  final Color? color;
  const ViewTimes({super.key, required this.times, this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: const TextStyle(
        height: 1,
      ),
      TextSpan(
        children: [
          const WidgetSpan(
            child: Align(
              alignment: Alignment.center,
              child: Image(
                width: 15,
                height: 17,
                image:
                    AssetImage('packages/shared/assets/images/play_count.webp'),
              ),
            ),
          ),
          WidgetSpan(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                ' ${formatNumberToUnit(times)}',
                style: TextStyle(
                  color: color ?? Colors.white,
                  letterSpacing: 0.1,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
