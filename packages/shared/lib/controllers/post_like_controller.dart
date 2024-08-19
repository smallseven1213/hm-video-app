import 'package:get/get.dart';
import 'package:shared/apis/post_api.dart';

class PostLikeController extends GetxController {
  final _likedPosts = <int, bool>{}.obs;
  final _likeCounts = <int, int>{}.obs;

  bool isPostLiked(int postId) {
    return _likedPosts[postId] ?? false;
  }

  int getLikeCount(int postId, int initialCount) {
    return _likeCounts[postId] ?? initialCount;
  }

  Future<void> toggleLike(int postId, int initialCount) async {
    bool currentLikeStatus = _likedPosts[postId] ?? false;
    bool newLikeStatus = !currentLikeStatus;

    int currentCount = _likeCounts[postId] ?? initialCount;
    int newCount = newLikeStatus ? currentCount + 1 : currentCount - 1;

    bool success = await PostApi().likePost(postId, newLikeStatus);

    if (success) {
      _likedPosts[postId] = newLikeStatus;
      _likeCounts[postId] = newCount;
    } else {}

    update();
  }

  // 初始化点赞状态
  void setLikeStatus(int postId, bool isLiked) {
    _likedPosts[postId] = isLiked;
  }

}
