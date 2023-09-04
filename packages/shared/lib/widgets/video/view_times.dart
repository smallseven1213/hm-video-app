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
          WidgetSpan(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.remove_red_eye_outlined,
                color: color ?? Colors.white,
                size: 16,
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
