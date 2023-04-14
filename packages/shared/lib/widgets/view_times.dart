import 'package:flutter/material.dart';
import 'package:shared/utils/video_info_formatter.dart';

class ViewTimes extends StatelessWidget {
  final int times;
  final Color? color;
  const ViewTimes({super.key, required this.times, this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.remove_red_eye_outlined,
              color: color ?? Colors.white,
              size: 16,
            ),
          ),
          TextSpan(
            text: ' ${getViewTimes(times)}',
            style: TextStyle(
              fontSize: 12,
              color: color ?? Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
