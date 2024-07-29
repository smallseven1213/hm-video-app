import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/auth_controller.dart';
import '../apis/post_api.dart';
import '../models/infinity_posts.dart';
import '../models/post_detail.dart';
import 'base_post_infinity_scroll_controller.dart';

const int limit = 5;
final PostApi postApi = PostApi();

class PostController extends GetxController {
  final int? postId;
  PostDetail? postDetail;

  PostController({required this.postId}) {
    getPostDetail();
    Get.find<AuthController>().token.listen((event) {
      getPostDetail();
    });
  }

  // get post detail
  Future<void> getPostDetail() async {
    var post = await postApi.getPostDetail(postId!);
    if (post != null) {
      postDetail = post;
      update();
    }
  }
}
