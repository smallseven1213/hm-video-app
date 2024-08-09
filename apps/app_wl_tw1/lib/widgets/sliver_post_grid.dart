import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_post_controller.dart';
import 'package:shared/widgets/posts/card.dart';
import 'package:shared/widgets/posts/horizontal_card.dart';
import 'package:shared/widgets/refresh_list.dart';

import 'list_no_more.dart';
import 'no_data.dart';
import 'reload_button.dart';
import 'sliver_video_preview_skelton_list.dart';

class SliverPostGrid extends StatefulWidget {
  final String? keyword;
  final int? tagId;
  final int? supplierId;
  final List<Widget>? headerExtends;
  final ScrollController? customScrollController;
  final bool? vertical;

  const SliverPostGrid({
    Key? key,
    this.keyword,
    this.tagId,
    this.supplierId,
    this.headerExtends,
    this.customScrollController,
    this.vertical = true,

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
      keyword: widget.keyword,
      tagId: widget.tagId,
      supplierId: widget.supplierId,
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
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => widget.vertical == true
                      ? PostCard(
                          detail: postController!.postList[index],
                        )
                      : PostHorizontalCard(
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
              const SliverToBoxAdapter(child: NoDataWidget()),
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
