import 'package:flutter/material.dart';
import 'package:shared/utils/video_info_formatter.dart';

class VideoTime extends StatelessWidget {
  final int time;
  final Color? color;
  final bool? hasIcon;

  const VideoTime({
    super.key,
    required this.time,
    this.color,
    this.hasIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: const TextStyle(height: 1),
      TextSpan(
        children: [
          hasIcon == true
              ? WidgetSpan(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.access_alarm,
                      color: color ?? Colors.white,
                      size: 16,
                    ),
                  ),
                )
              : const WidgetSpan(child: SizedBox()),
          const WidgetSpan(
            child: SizedBox(width: 2),
          ),
          WidgetSpan(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                ' ${getTimeString(time)}',
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
