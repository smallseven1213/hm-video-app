import 'package:app_gs/screens/filter/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/filter_result_controller.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import '../screens/filter/options.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/video_preview.dart';

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
  _FilterScrollViewState createState() => _FilterScrollViewState();
}

class _FilterScrollViewState extends State<FilterScrollView> {
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
        Obx(() {
          logger.i(
              'HAHAHA ${vodController.hasMoreData} THEN ${vodController.isLoading} HAHA ${vodController.vodList.length}');
          return CustomScrollView(
            controller: vodController.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FilterOptions(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverAlignedGrid.count(
                  crossAxisCount: 2,
                  itemCount: vodController.vodList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var video = vodController.vodList[index];
                    return VideoPreviewWidget(
                        id: video.id,
                        coverVertical: video.coverVertical!,
                        coverHorizontal: video.coverHorizontal!,
                        timeLength: video.timeLength!,
                        tags: video.tags!,
                        title: video.title,
                        videoViewTimes: video.videoViewTimes!);
                  },
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 10.0,
                ),
              ),
              if (vodController.hasMoreData.value)
                const SliverVideoPreviewSkeletonList(),
              if (!vodController.hasMoreData.value)
                const SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          );
        }),
        if (_showSelectedBar)
          FilterBar(
            scrollController: vodController.scrollController,
          ),
      ],
    );
  }
}
