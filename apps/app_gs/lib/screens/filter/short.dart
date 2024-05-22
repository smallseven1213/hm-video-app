import 'package:app_gs/screens/filter/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';
import 'package:shared/controllers/filter_short_result_controller.dart';
import 'package:shared/controllers/filter_short_screen_controller.dart';
import 'package:shared/controllers/filter_temp_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';
import 'options.dart';

class ShortVideoFilterPage extends StatefulWidget {
  const ShortVideoFilterPage({
    super.key,
  });

  @override
  VideoFilterScrollViewState createState() => VideoFilterScrollViewState();
}

class VideoFilterScrollViewState extends State<ShortVideoFilterPage> {
  final FilterScreenController filterScreenController = Get.find();
  late FilterScreenShortResultController vodController;
  final FilterShortScreenController filterShortScreenController =
      Get.find<FilterShortScreenController>();
  final ScrollController scrollController = ScrollController();
  final searchTempShortController = Get.find<FilterTempShortController>();
  late Worker everWorker;

  @override
  void initState() {
    super.initState();
    vodController =
        FilterScreenShortResultController(scrollController: scrollController);

    scrollController.addListener(() {
      if (scrollController.offset > 150 &&
          filterScreenController.showTabBar.value) {
        filterScreenController.handleOption(showTab: false, openOption: false);
      } else if (scrollController.offset < 150 &&
          !filterScreenController.showTabBar.value) {
        filterScreenController.handleOption(showTab: true, openOption: true);
      }
    });

    vodController.vodList.listen((p0) {
      searchTempShortController.replaceVideos(p0);
    });

    everWorker = ever(filterShortScreenController.selectedOptions, (_) {
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
              menuData: filterShortScreenController.menuData,
              selectedOptions: filterShortScreenController.selectedOptions,
              handleOptionChange:
                  filterShortScreenController.handleOptionChange,
              film: 2,
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
        displayVideoFavoriteTimes: false,
        noMoreWidget: ListNoMore(),
        customScrollController: vodController.scrollController,
        displayCoverVertical: true,
        onOverrideRedirectTap: (id) {
          MyRouteDelegate.of(context).push(AppRoutes.shortsByLocal,
              args: {'itemId': 4, 'videoId': id});
        },
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
