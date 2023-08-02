import 'package:app_gs/screens/filter/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';
import 'package:shared/controllers/filter_video_result_controller.dart';
import 'package:shared/controllers/filter_video_screen_controller.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';
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
      () => Stack(
        children: [
          SliverVodGrid(
            headerExtends: [
              SliverToBoxAdapter(
                child: FilterOptions(
                  menuData: filterVideoScreenController.menuData,
                  selectedOptions: filterVideoScreenController.selectedOptions,
                  handleOptionChange:
                      filterVideoScreenController.handleOptionChange,
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
          ),
          FilterBar(
            menuData: filterVideoScreenController.menuData,
            selectedOptions: filterVideoScreenController.selectedOptions,
            handleOptionChange: filterVideoScreenController.handleOptionChange,
            film: 1,
          ),
        ],
      ),
    );
  }
}
