import 'package:flutter/material.dart';
import 'package:shared/utils/video_info_formatter.dart';

class StatisticsItem extends StatelessWidget {
  final int count;
  final String label;

  const StatisticsItem({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          formatNumberToUnit(count),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
