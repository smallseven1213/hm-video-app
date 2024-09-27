import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_post_controller.dart';
import 'package:shared/widgets/posts/card/index.dart';
import 'package:shared/widgets/refresh_list.dart';
import 'package:shared/widgets/game_block_template/game_area.dart';
import 'package:shared/models/game.dart';
import '../../../widgets/list_no_more.dart';
import '../../../widgets/reload_button.dart';
import '../../../widgets/sliver_video_preview_skelton_list.dart';
import '../../../widgets/no_data.dart';

class Posts extends StatefulWidget {
  final int postId;
  final int areaId;
  final bool isActive;
  final List<Game>? gameBlocks;
  final bool isAreaAds;

  const Posts({
    Key? key,
    required this.postId,
    required this.areaId,
    required this.isActive,
    required this.isAreaAds,
    this.gameBlocks,
  }) : super(key: key);

  @override
  PostsState createState() => PostsState();
}

class PostsState extends State<Posts> {
  ScrollController? _scrollController;
  ChannelPostController? postController;
  Timer? _debounceTimer;
  bool isRefreshing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = PrimaryScrollController.of(context);
    postController ??= ChannelPostController(
      scrollController: _scrollController!,
      areaId: widget.areaId,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    postController?.dispose();
    super.dispose();
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
    bool showAds = widget.gameBlocks != null && widget.isAreaAds;
    if (postController == null) {
      return const SizedBox();
    }
    return Obx(() {
      return RefreshList(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    int actualIndex = index - (index ~/ 6);
                    //廣告區塊，待處理
                    if (index % 6 == 0 && index != 0 && showAds) {
                      int gameIndex = (index ~/ 6) % widget.gameBlocks!.length;
                      return GameArea(game: widget.gameBlocks![gameIndex]);
                    }
                    return PostCard(
                      detail: postController!
                          .postList[showAds ? actualIndex : index],
                    );
                  },
                  childCount: showAds
                      ? postController!.postList.length +
                          (postController!.postList.length ~/ 5)
                      : postController!.postList.length,
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
        ),
      );
    });
  }
}
