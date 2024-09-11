import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared/controllers/post_like_controller.dart';

class AppColors {
  static const contentText = Colors.white;
  static const darkText = Color(0xff919bb3);
}

class PostStatsWidget extends StatelessWidget {
  final int viewCount;
  final int likeCount;
  final int? postId;
  final bool? isInteractive;

  const PostStatsWidget({
    Key? key,
    required this.viewCount,
    required this.likeCount,
    required this.postId,
    this.isInteractive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.remove_red_eye, size: 15, color: AppColors.darkText),
          const SizedBox(width: 4),
          Text(
            viewCount.toString(),
            style: const TextStyle(fontSize: 13, color: AppColors.darkText),
          ),
          const SizedBox(width: 10),
          if (postId != null) _buildLikeButton() else _buildStaticLikeIcon(),
          const SizedBox(width: 4),
          _buildLikeCount(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return GetX<PostLikeController>(
      init: PostLikeController(),
      builder: (controller) {
        bool isLiked = controller.isPostLiked(postId!);
        return GestureDetector(
          onTap: isInteractive == true
              ? () => controller.toggleLike(postId!, likeCount)
              : null,
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 15,
            color: isLiked ? Colors.red : AppColors.darkText,
          ),
        );
      },
    );
  }

  Widget _buildStaticLikeIcon() {
    return const Icon(
      Icons.favorite_border,
      size: 15,
      color: AppColors.darkText,
    );
  }

  Widget _buildLikeCount() {
    if (postId == null) {
      return Text(
        likeCount.toString(),
        style: const TextStyle(fontSize: 13, color: AppColors.darkText),
      );
    }

    return GetX<PostLikeController>(
      builder: (controller) {
        int currentLikeCount = controller.getLikeCount(postId!, likeCount);
        return Text(
          currentLikeCount.toString(),
          style: const TextStyle(fontSize: 13, color: AppColors.darkText),
        );
      },
    );
  }
}
