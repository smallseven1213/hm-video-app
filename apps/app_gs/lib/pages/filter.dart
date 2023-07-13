import 'dart:async';

import 'package:app_gs/screens/filter/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/filter_result_controller.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import '../screens/filter/options.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';

final logger = Logger();

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterScrollViewState createState() => FilterScrollViewState();
}

class FilterScrollViewState extends State<FilterPage> {
  // DISPOSED SCROLL CONTROLLER
  final ScrollController scrollController = ScrollController();
  final FilterScreenController filterScreenController =
      Get.find<FilterScreenController>();
  late FilterScreenResultController vodController;
  bool _showSelectedBar = false;
  late Worker everWorker;

  @override
  void initState() {
    super.initState();

    vodController =
        FilterScreenResultController(scrollController: scrollController);

    vodController.scrollController?.addListener(() {
      if (vodController.scrollController!.position.pixels > 100) {
        if (!_showSelectedBar) {
          setState(() {
            _showSelectedBar = true;
          });
        }
      } else {
        if (_showSelectedBar) {
          setState(() {
            _showSelectedBar = false;
          });
        }
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
    return Scaffold(
      appBar: const CustomAppBar(
        title: '篩選',
      ),
      body: Stack(
        children: [
          Obx(() => SliverVodGrid(
                headerExtends: [
                  SliverToBoxAdapter(
                    child: FilterOptions(),
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
              )),
          if (_showSelectedBar)
            FilterBar(
              scrollController: vodController.scrollController!,
            ),
        ],
      ),
    );
  }
}
