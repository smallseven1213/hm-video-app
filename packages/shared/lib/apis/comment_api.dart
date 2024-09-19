import 'package:get/get.dart';
import '../controllers/system_config_controller.dart';
import '../models/comment.dart';
import '../utils/fetcher.dart';

class CommentApi {
  static final CommentApi _instance = CommentApi._internal();

  CommentApi._internal();

  factory CommentApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/api/v1';

  // 獲取評論列表
  Future<List<Comment>> getCommentList({
    int page = 1,
    int limit = 5,
    required int topicType,
    required int topicId,
  }) async {
    try {
      Map<String, String> queryParams = {
        'per_page': limit.toString(),
        'page': page.toString(),
        'topic_type': topicType.toString(),
        'topic_id': topicId.toString(),
      };

      var uri = Uri.parse('$apiPrefix/comments')
          .replace(queryParameters: queryParams);
      var res = await fetcher(url: uri.toString());

      if (res.data['code'] != '00') {
        return [];
      }

      var data = res.data['data'];
      List<Comment> comments = List.from(
          (data['items'] as List<dynamic>).map((e) => Comment.fromJson(e)));

      int total = data['meta']['total'];
      int retrievedLimit = data['meta']['per_page'];
      bool hasMoreData = total > retrievedLimit * page;
      return comments;
    } catch (e) {
      return [];
    }
  }

  // 新增評論
  Future<Comment?> createComment({
    required int topicType,
    required int topicId,
    required String content,
  }) async {
    try {
      var res = await fetcher(
        url: '$apiPrefix/comment/create',
        method: 'POST',
        body: {
          'topic_type': topicType,
          'topic_id': topicId,
          'content': content,
        },
      );

      if (res.data['code'] != '00') {
        return null;
      }

      return Comment.fromJson(res.data['data']);
    } catch (e) {
      return null;
    }
  }
}
