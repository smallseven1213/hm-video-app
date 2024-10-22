import 'package:get/get.dart';
import 'package:shared/apis/comment_api.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/models/comment.dart';

const int limit = 5;
final CommentApi commentApi = CommentApi();

class CommentController extends GetxController {
  final int topicType;
  final int topicId;
  final offset = 1.obs;
  RxBool isLoading = false.obs;
  RxList<Comment> comments = RxList<Comment>();
  RxList<Report> reportList = RxList<Report>();
  int _page = 1;
  bool _hasMoreData = true;
  RxString reportTitle = ''.obs;
  RxInt reportType = 0.obs;
  RxInt reportLength = 0.obs;

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
  Future<void> getComments({int page = 1, bool refresh = false}) async {
    if (isLoading.value || !_hasMoreData) return;

    isLoading.value = true;
    int nextPage;
    if (refresh) {
      offset.value = offset.value <= 5 ? offset.value + 1 : 1;
      nextPage = offset.value;
    } else {
      nextPage = page;
    }
    var commentList = await commentApi.getCommentList(
      topicType: topicType,
      topicId: topicId,
      page: nextPage,
    );

    if (commentList.isNotEmpty) {
      if (refresh) {
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

  // 下拉更新
  Future<void> pullToRefreshComments() async {
    await getComments(refresh: true);
  }

  // 检查是否有更多数据
  bool get hasMoreData => _hasMoreData;

  //刪除評論
  Future<void> commentDelete(int id, int index) async {
    var comment = await commentApi.commentDelete(
      id: id,
    );
    if (comment != null) {
      comments.removeAt(index);
      update();
    } else {
      // Handle error (e.g., show a snackbar)
      Get.snackbar('Error', 'Failed to comment delete');
    }
  }

  //舉報類型
  Future<void> commentReportType() async {
    var commentReportType = await commentApi.commentReportType();
    if (commentReportType.isNotEmpty) {
      reportList.value = commentReportType;
      update();
    } else {
      // Handle error (e.g., show a snackbar)
      Get.snackbar('Error', 'Failed to comment report type');
    }
  }

  //舉報評論
  Future<void> commentReport(int id, int reportType, String reason) async {
    var commentRepor = await commentApi.commentReport(
      id: id,
      type: reportType,
      reason: reason,
    );
    if (commentRepor == null) {
      // Handle error (e.g., show a snackbar)
      Get.snackbar('Error', 'Failed to comment report');
    }
  }
}
