import 'package:app_gs/screens/filter/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_short_result_controller.dart';
import 'package:shared/controllers/filter_short_screen_controller.dart';
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
  late FilterScreenShortResultController vodController;
  final FilterShortScreenController filterScreenController =
      Get.find<FilterShortScreenController>();
  final ScrollController scrollController = ScrollController();
  bool _showSelectedBar = false;
  late Worker everWorker;

  @override
  void initState() {
    super.initState();
    vodController =
        FilterScreenShortResultController(scrollController: scrollController);

    scrollController.addListener(() {
      if (scrollController.offset > 500 && !_showSelectedBar) {
        setState(() {
          _showSelectedBar = true;
        });
      } else if (scrollController.offset < 500 && _showSelectedBar) {
        setState(() {
          _showSelectedBar = false;
        });
      }
    });

    everWorker = ever(filterScreenController.selectedOptions, (_) {
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
                  menuData: filterScreenController.menuData,
                  handleOptionChange: filterScreenController.handleOptionChange,
                  selectedOptions: filterScreenController.selectedOptions,
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
          if (_showSelectedBar)
            FilterBar(
              scrollController: scrollController,
              menuData: filterScreenController.menuData,
              selectedOptions: filterScreenController.selectedOptions,
              handleOptionChange: filterScreenController.handleOptionChange,
            ),
        ],
      ),
    );
  }
}
