import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';
import '../apis/post_api.dart';
import '../models/post_detail.dart';

const int limit = 5;
final PostApi postApi = PostApi();

class PostController extends GetxController {
  final int postId;

  RxBool isLoading = false.obs;
  var postDetail = Rx<PostDetail?>(null);

  PostController({required this.postId}) {
    getPostDetail(postId);
    Get.find<AuthController>().token.listen((event) {
      getPostDetail(postId);
    });
  }

  // get post detail
  Future<void> getPostDetail(int postId) async {
    isLoading.value = true;
    var post = await postApi.getPostDetail(postId);
    if (post != null) {
      postDetail.value = post;
      update();
      isLoading.value = false;
    }
  }

}
