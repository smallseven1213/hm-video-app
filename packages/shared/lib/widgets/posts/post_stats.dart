import 'package:flutter/material.dart';
import 'package:shared/apis/post_api.dart';

// 定義顏色配置
class AppColors {
  static const contentText = Colors.white;
  static const darkText = Color(0xff919bb3);
}

class PostStatsWidget extends StatefulWidget {
  final int viewCount;
  final int likeCount;
  final int? postId; // 將 postId 設為可選
  final bool? isLiked;

  const PostStatsWidget({
    Key? key,
    required this.viewCount,
    required this.likeCount,
    this.postId,
    this.isLiked,
  }) : super(key: key);

  @override
  _PostStatsWidgetState createState() => _PostStatsWidgetState();
}

class _PostStatsWidgetState extends State<PostStatsWidget> {
  late int likeCount;
  bool? isLiked;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likeCount;
    isLiked = widget.isLiked;
  }

  void _toggleLike() async {
    if (isLiked == null || widget.postId == null)
      return; // 如果 isLiked 或 postId 為 null，則直接返回

    bool success = await PostApi().likePost(widget.postId!, !isLiked!);
    if (success) {
      setState(() {
        isLiked = !isLiked!;
        likeCount += isLiked! ? 1 : -1;
      });
    } else {
      // Handle the failure (e.g., show a message to the user)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update like status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.remove_red_eye, size: 15, color: AppColors.darkText),
          const SizedBox(width: 4),
          Text(
            widget.viewCount.toString(),
            style: const TextStyle(fontSize: 13, color: AppColors.darkText),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap:
                (isLiked != null && widget.postId != null) ? _toggleLike : null,
            child: Icon(
              isLiked == true ? Icons.favorite : Icons.favorite_border,
              size: 15,
              color: isLiked == true ? Colors.red : AppColors.darkText,
            ),
          ),
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
