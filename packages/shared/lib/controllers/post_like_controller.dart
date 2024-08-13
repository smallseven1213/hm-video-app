import 'package:get/get.dart';

class PostLikeController extends GetxController {
  final _likedPosts = <int, bool>{}.obs;
  final _likeCounts = <int, int>{}.obs;

  bool isPostLiked(int postId) {
    return _likedPosts[postId] ?? false;
  }

  int getLikeCount(int postId, int initialCount) {
    return _likeCounts[postId] ?? initialCount;
  }

  void toggleLike(int postId, int initialCount) {
    bool currentLikeStatus = _likedPosts[postId] ?? false;
    _likedPosts[postId] = !currentLikeStatus;

    int currentCount = _likeCounts[postId] ?? initialCount;
    _likeCounts[postId] =
        !currentLikeStatus ? currentCount + 1 : currentCount - 1;

    update();
  }

  // 初始化点赞状态
  void setLikeStatus(int postId, bool isLiked) {
    _likedPosts[postId] = isLiked;
  }
}
