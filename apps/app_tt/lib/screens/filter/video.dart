import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';
import 'package:shared/controllers/filter_video_result_controller.dart';
import 'package:shared/controllers/filter_video_screen_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';
import 'filter_bar.dart';
import 'options.dart';

class VideoFilterPage extends StatefulWidget {
  const VideoFilterPage({
    super.key,
  });

  @override
  VideoFilterScrollViewState createState() => VideoFilterScrollViewState();
}

class VideoFilterScrollViewState extends State<VideoFilterPage> {
  final FilterScreenController filterScreenController = Get.find();
  late FilterVideoScreenResultController vodController;
  final FilterVideoScreenController filterVideoScreenController =
      Get.find<FilterVideoScreenController>();
  final ScrollController scrollController = ScrollController();
  late Worker everWorker;

  @override
  void initState() {
    super.initState();
    vodController =
        FilterVideoScreenResultController(scrollController: scrollController);

    scrollController.addListener(() {
      if (scrollController.offset > 150 &&
          filterScreenController.showTabBar.value) {
        filterScreenController.handleOption(showTab: false, openOption: false);
      } else if (scrollController.offset < 150 &&
          !filterScreenController.showTabBar.value) {
        filterScreenController.handleOption(showTab: true, openOption: true);
      }
    });

    everWorker = ever(filterVideoScreenController.selectedOptions, (_) {
      vodController.reset();
      vodController.loadMoreData();
    });
  }

  @override
  void dispose() {
    everWorker.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverVodGrid(
        headerExtends: [
          SliverPersistentHeader(
            pinned: true,
            delegate: CustomHeaderDelegate(
              minHeight: 64.0, // 這是FilterBar的高度
              maxHeight: 120.0, // 這是FilterOptions的高度
              menuData: filterVideoScreenController.menuData,
              selectedOptions: filterVideoScreenController.selectedOptions,
              handleOptionChange:
                  filterVideoScreenController.handleOptionChange,
              film: 1,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          )
        ],
        videos: vodController.vodList.value,
        isListEmpty: vodController.isListEmpty.value,
        displayNoMoreData: vodController.displayNoMoreData.value,
        displayLoading: vodController.displayLoading.value,
        displayVideoCollectTimes: false,
        noMoreWidget: ListNoMore(),
        customScrollController: vodController.scrollController,
      ),
    );
  }
}

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final RxList<Map<String, dynamic>> menuData;
  final RxMap<String, Set> selectedOptions;
  final void Function(String key, dynamic value) handleOptionChange;
  final int film;

  CustomHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.menuData,
    required this.selectedOptions,
    required this.handleOptionChange,
    required this.film,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (shrinkOffset >= 100) {
      return FilterBar(
        menuData: menuData,
        selectedOptions: selectedOptions,
        handleOptionChange: handleOptionChange,
        film: film,
      );
    } else {
      return FilterOptions(
        menuData: menuData,
        selectedOptions: selectedOptions,
        handleOptionChange: handleOptionChange,
      );
    }
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
