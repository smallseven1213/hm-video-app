import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_vod_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';

class TagForVideos extends StatefulWidget {
  final int tagId;
  const TagForVideos({
    Key? key,
    required this.tagId,
  }) : super(key: key);

  @override
  TagForVideosState createState() => TagForVideosState();
}

class TagForVideosState extends State<TagForVideos> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();
  late final TagVodController vodController = TagVodController(
    tagId: widget.tagId,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() => SliverVodGrid(
          isListEmpty: vodController.isListEmpty.value,
          videos: vodController.vodList.value,
          displayNoMoreData: vodController.displayNoMoreData.value,
          displayLoading: vodController.displayLoading.value,
          noMoreWidget: ListNoMore(),
          customScrollController: vodController.scrollController,
        ));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
