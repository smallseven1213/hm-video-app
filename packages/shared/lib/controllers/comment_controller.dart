import 'package:get/get.dart';
import 'package:shared/apis/comment_api.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/models/comment.dart';

const int limit = 5;
final CommentApi commentApi = CommentApi();

class CommentController extends GetxController {
  final int topicType;
  final int topicId;
  RxBool isLoading = false.obs;
  RxList<Comment> comments = RxList<Comment>();

  int _page = 1;
  bool _hasMoreData = true;

  CommentController({
    required this.topicType,
    required this.topicId,
  }) {
    getComments(page: _page);
    Get.find<AuthController>().token.listen((event) {
      _page = 1;
      _hasMoreData = true;
      comments.clear();
      getComments(page: _page);
    });
  }

  // Add this method to handle comment creation
  Future<void> createComment(String content) async {
    var comment = await commentApi.createComment(
      topicType: topicType,
      topicId: topicId,
      content: content,
    );
    if (comment != null) {
      comments.insert(0, comment);
      update();
    } else {
      // Handle error (e.g., show a snackbar)
      Get.snackbar('Error', 'Failed to post comment');
    }
  }

  // 获取评论列表，支持分页
  Future<void> getComments({int page = 1}) async {
    if (isLoading.value || !_hasMoreData) return;

    isLoading.value = true;
    var commentList = await commentApi.getCommentList(
      topicType: topicType,
      topicId: topicId,
      page: page,
    );

    if (commentList.isNotEmpty) {
      if (page == 1) {
        comments.value = commentList;
      } else {
        comments.addAll(commentList);
      }
      _page = page;
    } else {
      _hasMoreData = false;
    }

    isLoading.value = false;
  }

  // 加载更多评论
  Future<void> loadMoreComments() async {
    if (isLoading.value || !_hasMoreData) return;
    await getComments(page: _page + 1);
  }

  // 检查是否有更多数据
  bool get hasMoreData => _hasMoreData;
}
