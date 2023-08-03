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
      () => Stack(
        children: [
          SliverVodGrid(
            headerExtends: [
              SliverToBoxAdapter(
                child: FilterOptions(
                  menuData: filterShortScreenController.menuData,
                  handleOptionChange:
                      filterShortScreenController.handleOptionChange,
                  selectedOptions: filterShortScreenController.selectedOptions,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              )
            ],
            videos: vodController.vodList,
            isListEmpty: vodController.isListEmpty.value,
            displayNoMoreData: vodController.displayNoMoreData.value,
            displayLoading: vodController.displayLoading.value,
            displayVideoCollectTimes: false,
            noMoreWidget: ListNoMore(),
            customScrollController: vodController.scrollController,
            displayCoverVertical: true,
            onOverrideRedirectTap: (id) {
              MyRouteDelegate.of(context).push(AppRoutes.shortsByLocal,
                  args: {'itemId': 4, 'videoId': id});
            },
          ),
          FilterBar(
            menuData: filterShortScreenController.menuData,
            selectedOptions: filterShortScreenController.selectedOptions,
            handleOptionChange: filterShortScreenController.handleOptionChange,
            film: 2,
          ),
        ],
      ),
    );
  }
}
