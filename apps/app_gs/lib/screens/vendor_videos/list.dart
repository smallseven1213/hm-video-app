import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/publisher_hottest_vod_controller.dart';
import 'package:shared/controllers/publisher_latest_vod_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_video_preview_skelton_list.dart';
import '../../widgets/sliver_vod_grid.dart';
import '../../widgets/video_preview.dart';

class VendorVideoList extends StatelessWidget {
  final String type;
  final int publisherId;
  final scrollController = ScrollController();
  VendorVideoList({Key? key, required this.type, required this.publisherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publisherVodController = type == 'hot'
        ? PublisherHottestVodController(
            publisherId: publisherId, scrollController: scrollController)
        : PublisherLatestVodController(
            publisherId: publisherId, scrollController: scrollController);

    return SliverVodGrid(
      videos: publisherVodController.vodList,
      hasMoreData: publisherVodController.hasMoreData.value,
      noMoreWidget: const ListNoMore(),
      scrollController: publisherVodController.scrollController,
    );
  }
}
