import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../apis/post_api.dart';
import '../models/infinity_posts.dart';
import 'base_post_infinity_scroll_controller.dart';

final postApi = PostApi();
const limit = 5;
final logger = Logger();

class ChannelPostController extends BasePostInfinityScrollController {
  final int postId;
  RxInt postCount = 0.obs;
  var isError = false.obs;

  ChannelPostController({
    required this.postId,
    required ScrollController scrollController,
    required bool autoDisposeScrollController,
    required bool hasLoadMoreEventWithScroller,
    bool loadDataOnInit = true,
  }) : super(
          loadDataOnInit: loadDataOnInit,
          customScrollController: scrollController,
          autoDisposeScrollController: autoDisposeScrollController,
          hasLoadMoreEventWithScroller: hasLoadMoreEventWithScroller,
        );

  @override
  Future<InfinityPosts> fetchData(int page) async {
    try {
      InfinityPosts res = await postApi.getPostList(page: page, limit: limit);
      bool hasMoreData = res.totalCount! > limit * page;
      postCount.value = res.totalCount ?? 0;
      isError.value = false;
      return InfinityPosts(res.posts, res.totalCount, hasMoreData);
    } catch (e) {
      logger.e(e);
      isError.value = true;
      return InfinityPosts([], 0, false);
    }
  }
}
