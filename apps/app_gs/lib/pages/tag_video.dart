import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_vod_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';

class TagVideoPage extends StatefulWidget {
  final int id;
  final String title;

  TagVideoPage({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  _TagVideoPageState createState() => _TagVideoPageState();
}

class _TagVideoPageState extends State<TagVideoPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '#${widget.title}',
      ),
      body: Obx(() {
        return SliverVodGrid(
          videos: vodController.vodList,
          hasMoreData: vodController.hasMoreData.value,
          noMoreWidget: const ListNoMore(),
          customScrollController: vodController.scrollController,
        );
      }),
    );
  }
}
