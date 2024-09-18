import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared/controllers/post_like_controller.dart';
import 'package:shared/widgets/comment/comment_bottom_sheet.dart';

class AppColors {
  static const contentText = Color(0xff919bb3);
  static const background = Colors.black;
}

class PostStatsWidget extends StatelessWidget {
  final int viewCount;
  final int likeCount;
  final int replyCount;
  final int? postId;
  final bool? isInteractive;

  const PostStatsWidget({
    Key? key,
    required this.viewCount,
    required this.likeCount,
    required this.replyCount,
    required this.postId,
    this.isInteractive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.remove_red_eye_outlined, viewCount),
          _buildLikeItem(),
          _buildCommentItem(context),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.contentText),
        const SizedBox(width: 10),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 14, color: AppColors.contentText),
        ),
      ],
    );
  }

  Widget _buildLikeItem() {
    if (postId == null) {
      return _buildStatItem(Icons.favorite_border, likeCount);
    }

    return GetX<PostLikeController>(
      init: PostLikeController(),
      builder: (controller) {
        bool isLiked = controller.isPostLiked(postId!);
        int currentLikeCount = controller.getLikeCount(postId!, likeCount);
        return GestureDetector(
          onTap: isInteractive == true
              ? () => controller.toggleLike(postId!, likeCount)
              : null,
          child: Row(
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isLiked ? Colors.red : AppColors.contentText,
              ),
              const SizedBox(width: 4),
              Text(
                currentLikeCount.toString(),
                style:
                    const TextStyle(fontSize: 14, color: AppColors.contentText),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentItem(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCommentBottomSheet(context),
      child: _buildStatItem(Icons.chat_bubble_outline_rounded, replyCount),
    );
  }

  void _showCommentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // 啟用點擊外部區域自動關閉
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5), // 可選：設置點擊外部的遮罩顏色和透明度
      builder: (BuildContext context) {
        return CommentBottomSheet(
          postId: postId!,
        ); // 保持原本的 CommentBottomSheet
      },
    );
  }
}
