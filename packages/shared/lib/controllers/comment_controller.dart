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
  RxBool isCreatingComment = false.obs;
  RxList<Comment> comments = RxList<Comment>();

  CommentController({
    required this.topicType,
    required this.topicId,
  }) {
    getComments(topicType, topicId);
    Get.find<AuthController>().token.listen((event) {
      getComments(topicType, topicId);
    });
  }

  // Add this method to handle comment creation

  Future<void> createComment(String content) async {
    isCreatingComment.value = true;
    var comment = await commentApi.createComment(
      topicType: topicType,
      topicId: topicId,
      content: content,
    );
    isCreatingComment.value = false;
    if (comment != null) {
      print(content);
      comments.add(comment);
      update();
    } else {
      // Handle error (e.g., show a snackbar)
      Get.snackbar('Error', 'Failed to post comment');
    }
  }

  // get comment detail
  Future<void> getComments(int topicType, int topicId) async {
    isLoading.value = true;
    var comment =
        await commentApi.getCommentList(topicType: topicType, topicId: topicId);
    comments.value = comment;
    update();
    isLoading.value = false;
  }
}
