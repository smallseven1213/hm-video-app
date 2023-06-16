import 'package:flutter/material.dart';
import 'package:shared/controllers/publisher_hottest_vod_controller.dart';
import 'package:shared/controllers/publisher_latest_vod_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';

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
      isListEmpty: publisherVodController.isListEmpty.value,
      videos: publisherVodController.vodList,
      displayNoMoreData: publisherVodController.displayNoMoreData.value,
      displayLoading: publisherVodController.displayLoading.value,
      noMoreWidget: ListNoMore(),
      customScrollController: publisherVodController.scrollController,
    );
  }
}
