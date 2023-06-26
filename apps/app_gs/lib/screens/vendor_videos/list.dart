import 'package:flutter/material.dart';
import 'package:shared/controllers/publisher_hottest_vod_controller.dart';
import 'package:shared/controllers/publisher_latest_vod_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';

class VendorVideoList extends StatefulWidget {
  final String type;
  final int publisherId;

  const VendorVideoList(
      {Key? key, required this.type, required this.publisherId})
      : super(key: key);

  @override
  VendorVideoListState createState() => VendorVideoListState();
}

class VendorVideoListState extends State<VendorVideoList> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final publisherVodController = widget.type == 'hot'
        ? PublisherHottestVodController(
            publisherId: widget.publisherId, scrollController: scrollController)
        : PublisherLatestVodController(
            publisherId: widget.publisherId,
            scrollController: scrollController);

    return SliverVodGrid(
      isListEmpty: publisherVodController.isListEmpty.value,
      videos: publisherVodController.vodList,
      displayNoMoreData: publisherVodController.displayNoMoreData.value,
      displayLoading: publisherVodController.displayLoading.value,
      noMoreWidget: ListNoMore(),
      customScrollController: publisherVodController.scrollController,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
