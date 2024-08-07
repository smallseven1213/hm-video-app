import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_post_controller.dart';
import 'package:shared/widgets/posts/horizontal_card.dart';
import 'package:shared/widgets/refresh_list.dart';

import 'no_data.dart';
import 'sliver_video_preview_skelton_list.dart';

class SliverPostGrid extends StatefulWidget {
  final int tagId;
  final Widget? noMoreWidget;
  final List<Widget>? headerExtends;
  final Function? onScrollEnd;
  final ScrollController? customScrollController;

  const SliverPostGrid({
    Key? key,
    required this.tagId,
    this.noMoreWidget,
    this.headerExtends,
    this.onScrollEnd,
    this.customScrollController,
  }) : super(key: key);

  @override
  SliverPostGridState createState() => SliverPostGridState();
}

class SliverPostGridState extends State<SliverPostGrid> {
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
    _scrollController =
        widget.customScrollController ?? PrimaryScrollController.of(context);
    _scrollController!.addListener(_scrollListener);
    postController ??= ChannelPostController(
      tagId: widget.tagId,
      limit: 10,
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
    setState(() {
      isRefreshing = false;
    });
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
          key: Key(widget.tagId.toString()),
          slivers: [
            if (postController!.isListEmpty.value)
              const SliverToBoxAdapter(
                child: NoDataWidget(),
              ),
            SliverPadding(
              padding: const EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => PostHorizontalCard(
                    detail: postController!.postList[index],
                  ),
                  childCount: postController!.postList.length,
                ),
              ),
            ),
            if (postController!.displayLoading.value && !isRefreshing)
              const SliverVideoPreviewSkeletonList(),
            if (postController!.displayNoMoreData.value)
              SliverToBoxAdapter(
                child: widget.noMoreWidget,
              ),
          ],
        );
      }),
    );
  }
}
