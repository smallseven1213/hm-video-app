import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/post_like_controller.dart';
import '../apis/post_api.dart';
import '../models/infinity_posts.dart';
import 'base_post_infinity_scroll_controller.dart';

final postApi = PostApi();
final logger = Logger();

class ChannelPostController extends BasePostInfinityScrollController {
  final String? keyword;
  final int? supplierId;
  final int? publisherId;
  final int? tagId;
  final int? topicId;
  final RxInt postCount = 0.obs;
  final int? limit;
  final int? areaId;

  var isError = false.obs;

  final PostLikeController _postLikeController = Get.find<PostLikeController>();

  ChannelPostController({
    required ScrollController scrollController,
    this.keyword,
    this.supplierId,
    this.publisherId,
    this.tagId,
    this.topicId,
    this.limit = 5,
    this.areaId,
    bool loadDataOnInit = true,
  }) : super(
          loadDataOnInit: loadDataOnInit,
          customScrollController: scrollController,
        );

  @override
  Future<InfinityPosts> fetchData(int page) async {
    try {
      InfinityPosts res = await postApi.getPostList(
        page: page,
        limit: limit ?? 5,
        keyword: keyword,
        supplierId: supplierId,
        publisherId: publisherId,
        tagId: tagId,
        topicId: topicId,
        areaId: areaId,
      );
      bool hasMoreData = res.totalCount > limit! * page;
      postCount.value = res.totalCount;
      isError.value = false;

      // 初始化点赞状态到 PostLikeController
      for (var post in res.posts) {
        _postLikeController.setLikeStatus(post.id, post.isLike ?? false);
      }

      return InfinityPosts(res.posts, res.totalCount, hasMoreData);
    } catch (e) {
      logger.e(e);
      isError.value = true;
      return InfinityPosts([], 0, false);
    }
  }
}
