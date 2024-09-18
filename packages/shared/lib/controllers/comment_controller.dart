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
  var comments = RxList<Comment>([]);

  CommentController({
    required this.topicType,
    required this.topicId,
  }) {
    getComments(topicType, topicId);
    Get.find<AuthController>().token.listen((event) {
      getComments(topicType, topicId);
    });
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
