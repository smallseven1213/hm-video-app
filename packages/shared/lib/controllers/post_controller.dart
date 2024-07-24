import 'package:flutter/material.dart';
import '../apis/post_api.dart';
import '../models/infinity_posts.dart';
import 'base_post_infinity_scroll_controller.dart';

const int limit = 5;
final PostApi postApi = PostApi();

class PostController extends BasePostInfinityScrollController {
  final int? postId;

  PostController({
    this.postId,
    required ScrollController scrollController,
    bool loadDataOnInit = true,
  }) : super(
            loadDataOnInit: loadDataOnInit,
            customScrollController: scrollController);

  @override
  Future<InfinityPosts> fetchData(int page) async {
    InfinityPosts res = await postApi.getPostList(page: page, limit: limit);

    bool hasMoreData = res.totalCount > limit * page;

    return InfinityPosts(res.posts, res.totalCount, hasMoreData);
  }
}
