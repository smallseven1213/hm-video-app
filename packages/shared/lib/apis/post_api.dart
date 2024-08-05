import 'package:game/models/hm_api_response_pagination.dart';
import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../models/infinity_posts.dart';
import '../models/post.dart';
import '../models/post_detail.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

class PostApi {
  static final PostApi _instance = PostApi._internal();

  PostApi._internal();

  factory PostApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/api/v1/post';

  Future<InfinityPosts> getPostList({
    int page = 1,
    limit = 5,
  }) async {
    try {
      var res = await fetcher(
          url: '$apiPrefix/list?per_page=$limit&current_page=$page');
      if (res.data['code'] != '00') {
        return InfinityPosts([], 0, false);
      }
      var data = res.data['data'];
      List<Post> posts = List.from(
          (data['items'] as List<dynamic>).map((e) => Post.fromJson(e)));

      int total = data['meta']['total'];
      int retrievedLimit = data['meta']['per_page'];
      bool hasMoreData = total > retrievedLimit * page;
      return InfinityPosts(posts, total, hasMoreData);
    } catch (e) {
      return InfinityPosts([], 0, false);
    }
  }

  // getPostDetail
  // post/detail?id=1
  Future<PostDetail?> getPostDetail(int id) async {
    try {
      var res = await fetcher(url: '$apiPrefix/detail?id=$id');
      if (res.data['code'] != '00') {
        return null;
      }
      var data = res.data['data'];
      return PostDetail.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
