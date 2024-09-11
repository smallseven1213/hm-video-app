import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/posts/card/index.dart';
import 'package:shared/controllers/channel_post_controller.dart';
import 'package:shared/widgets/refresh_list.dart';
import '../../../widgets/list_no_more.dart';
import '../../../widgets/reload_button.dart';
import '../../../widgets/sliver_video_preview_skelton_list.dart';
import '../../../widgets/no_data.dart';

class ChannelStyle7Main extends StatefulWidget {
  final int postId;

  const ChannelStyle7Main({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  ChannelStyle7MainState createState() => ChannelStyle7MainState();
}

class ChannelStyle7MainState extends State<ChannelStyle7Main> {
  ScrollController? _scrollController;
  ChannelPostController? postController;
  Timer? _debounceTimer;
  bool isRefreshing = false;

  void _scrollListener() {
    if (isRefreshing) return;
    if (_scrollController!.position.pixels >=
        _scrollController!.position.maxScrollExtent - 30) {
      debounce(
        fn: () => postController!.loadMoreData(),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = PrimaryScrollController.of(context);
    _scrollController!.addListener(_scrollListener);
    postController ??= ChannelPostController(
      scrollController: _scrollController!,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    postController?.dispose();
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  void debounce({required Function() fn, int waitForMs = 500}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  void _onRefresh() async {
    setState(() {
      isRefreshing = true;
    });
    postController!.reset();
    postController!.pullToRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshList(
      onRefresh: _onRefresh,
      child: Obx(() {
        if (postController == null) {
          return const SizedBox();
        }
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => PostCard(
                    detail: postController!.postList[index],
                  ),
                  childCount: postController!.postList.length,
                ),
              ),
            ),
            if (postController!.isError.value)
              SliverFillRemaining(
                child: Center(
                  child: ReloadButton(
                    onPressed: () => _onRefresh(),
                  ),
                ),
              ),
            if (!postController!.isError.value &&
                postController!.isListEmpty.value)
              const SliverToBoxAdapter(
                child: NoDataWidget(),
              ),
            if (postController!.displayLoading.value && !isRefreshing)
              const SliverVideoPreviewSkeletonList(),
            if (postController!.displayNoMoreData.value)
              SliverToBoxAdapter(child: ListNoMore()),
          ],
        );
      }),
    );
  }
}
