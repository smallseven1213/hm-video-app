import 'package:flutter/material.dart';

class StatisticsRow extends StatelessWidget {
  final String likes;
  final String videos;

  const StatisticsRow({
    super.key,
    required this.likes,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatisticItem(likes, '讚數'),
        const SizedBox(width: 20),
        _buildStatisticItem(videos, '作品'),
      ],
    );
  }

  Widget _buildStatisticItem(String count, String label) {
    return Row(
      children: [
        Text(
          count,
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
            color: Color(0xFF73747b),
          ),
        ),
      ],
    );
  }
}


