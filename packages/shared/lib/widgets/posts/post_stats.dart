import 'package:flutter/material.dart';

// 定義顏色配置
class AppColors {
  static const contentText = Colors.white;
  static const darkText = Color(0xff919bb3);
}

class PostStatsWidget extends StatelessWidget {
  final int viewCount;
  final int likeCount;

  const PostStatsWidget({
    Key? key,
    required this.viewCount,
    required this.likeCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.remove_red_eye, size: 15, color: AppColors.darkText),
          const SizedBox(width: 4),
          Text(
            viewCount.toString(),
            style: const TextStyle(fontSize: 13, color: AppColors.darkText),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.favorite, size: 15, color: AppColors.darkText),
          const SizedBox(width: 4),
          Text(
            likeCount.toString(),
            style: const TextStyle(fontSize: 13, color: AppColors.darkText),
          ),
        ],
      ),
    );
  }
}
