import 'package:flutter/material.dart';
import 'package:shared/widgets/posts/card/index.dart';
import 'package:shared/widgets/posts/horizontal_card.dart';

import 'list_no_more.dart';
import 'no_data.dart';
import 'reload_button.dart';
import 'sliver_video_preview_skelton_list.dart';

class SliverPostGrid extends StatelessWidget {
  final List posts;
  final bool isError;
  final bool isListEmpty;
  final bool displayLoading;
  final bool displayNoMoreData;
  final Function() onReload;
  final Function() onScrollEnd;
  final bool vertical;
  final bool displaySupplierInfo;
  final ScrollController? customScrollController;
  final List<Widget>? headerExtends;

  const SliverPostGrid({
    Key? key,
    required this.posts,
    required this.isError,
    required this.isListEmpty,
    required this.displayLoading,
    required this.displayNoMoreData,
    required this.onReload,
    required this.onScrollEnd,
    this.vertical = true,
    this.displaySupplierInfo = true,
    this.customScrollController,
    this.headerExtends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: customScrollController,
      slivers: [
        ...?headerExtends,
        if (isError)
          SliverFillRemaining(
            child: Center(
              child: ReloadButton(onPressed: onReload),
            ),
          ),
        if (isListEmpty) const SliverToBoxAdapter(child: NoDataWidget()),
        if (!isListEmpty)
          SliverPadding(
            padding: const EdgeInsets.all(0.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final post = posts[index];
                  return vertical
                      ? PostCard(
                          detail: post,
                          displaySupplierInfo: displaySupplierInfo,
                        )
                      : PostHorizontalCard(
                          detail: post,
                        );
                },
                childCount: posts.length,
              ),
            ),
          ),
        if (displayLoading) const SliverVideoPreviewSkeletonList(),
        if (displayNoMoreData) SliverToBoxAdapter(child: ListNoMore()),
      ],
    );
  }
}
