import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_vod_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';

class TagVideoPage extends StatefulWidget {
  final int id;
  final String title;

  const TagVideoPage({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  TagVideoPageState createState() => TagVideoPageState();
}

class TagVideoPageState extends State<TagVideoPage> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();
  late final TagVodController vodController;

  @override
  void initState() {
    super.initState();
    vodController = TagVodController(
      tagId: widget.id,
      scrollController: scrollController,
    );
  }

  @override
  void dispose() {
    vodController.dispose();
    if (scrollController.hasClients) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '#${widget.title}',
      ),
      body: Obx(() {
        return SliverVodGrid(
          isListEmpty: vodController.isListEmpty.value,
          displayVideoCollectTimes: false,
          videos: vodController.vodList,
          displayNoMoreData: vodController.displayNoMoreData.value,
          displayLoading: vodController.displayLoading.value,
          noMoreWidget: ListNoMore(),
          customScrollController: vodController.scrollController,
        );
      }),
    );
  }
}
