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

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(
          title: '篩選',
        ),
        body: FilterScrollView());
  }
}

class FilterScrollView extends StatefulWidget {
  const FilterScrollView({super.key});

  @override
  FilterScrollViewState createState() => FilterScrollViewState();
}

class FilterScrollViewState extends State<FilterScrollView> {
  final ScrollController scrollController = ScrollController();
  final FilterScreenController filterScreenController =
      Get.find<FilterScreenController>();
  late FilterScreenResultController vodController;
  bool _showSelectedBar = false;

  @override
  void initState() {
    super.initState();

    vodController =
        FilterScreenResultController(scrollController: scrollController);

    vodController.scrollController.addListener(() {
      if (vodController.scrollController.position.pixels > 100) {
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

    ever(filterScreenController.selectedOptions, (_) {
      vodController.reset();
      vodController.loadMoreData();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliverVodGrid(
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
          hasMoreData: vodController.hasMoreData.value,
          displayVideoCollectTimes: false,
          noMoreWidget: ListNoMore(),
          customScrollController: vodController.scrollController,
        ),
        if (_showSelectedBar)
          FilterBar(
            scrollController: vodController.scrollController,
          ),
      ],
    );
  }
}
