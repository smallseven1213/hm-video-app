import 'package:game/models/hm_api_response_pagination.dart';
import 'package:get/get.dart';
import '../controllers/system_config_controller.dart';
import '../models/infinity_posts.dart';
import '../models/post.dart';
import '../models/post_detail.dart';
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
    int limit = 5,
    String? keyword,
    int? supplierId,
    int? publisherId,
    int? tagId,
    int? topicId,
  }) async {
    try {
      Map<String, String> queryParams = {
        'per_page': limit.toString(),
        'page': page.toString(),
      };

      if (keyword != null) queryParams['keyword'] = keyword;
      if (supplierId != null)
        queryParams['supplier_id'] = supplierId.toString();
      if (publisherId != null)
        queryParams['publisher_id'] = publisherId.toString();
      if (tagId != null) queryParams['tag_id'] = tagId.toString();
      if (topicId != null) queryParams['topic_id'] = topicId.toString();

      var uri =
          Uri.parse('$apiPrefix/list').replace(queryParameters: queryParams);

      var res = await fetcher(url: uri.toString());
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

  // 貼文按讚
  // 貼文按讚：{{api_host}}/api/{{api_version}}/post/like
  // {
  //     "id": 34,
  //     "isLike": 1  // 1=按讚 0=取消按讚
  // }
  Future<bool> likePost(int id, bool isLike) async {
    try {
      var res = await fetcher(
        url: '$apiPrefix/like',
        method: 'POST',
        body: {
          'id': id,
          'isLike': isLike ? 1 : 0,
        },
      );
      return res.data['code'] == '00';
    } catch (e) {
      return false;
    }
  }

}
