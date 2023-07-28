import 'dart:async';

import 'package:app_gs/screens/filter/filter_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/filter_result_controller.dart';
import 'package:shared/controllers/filter_screen_controller.dart';
import 'package:shared/controllers/filter_short_result_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import '../screens/filter/options.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';
import '../widgets/tab_bar.dart';

final logger = Logger();

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  FilterScrollViewState createState() => FilterScrollViewState();
}

class FilterScrollViewState extends State<FilterPage>
    with SingleTickerProviderStateMixin {
  // DISPOSED SCROLL CONTROLLER
  late TabController _tabController;
  final ScrollController scrollController = ScrollController();
  final FilterScreenController filterScreenController =
      Get.find<FilterScreenController>();
  late FilterScreenResultController vodController;
  late FilterScreenShortResultController shortVodController;

  bool _showSelectedBar = false;
  late Worker everWorker;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    vodController =
        FilterScreenResultController(scrollController: scrollController);
    shortVodController =
        FilterScreenShortResultController(scrollController: scrollController);
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
      body: NestedScrollView(
        physics: kIsWeb ? null : const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // 返回一个 Sliver 数组给外部可滚动组件。
          return <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarHeaderDelegate(_tabController),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: kIsWeb ? null : const BouncingScrollPhysics(),
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            Stack(
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
            Stack(
              children: [
                Obx(
                  () => SliverVodGrid(
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
                      videos: shortVodController.vodList,
                      isListEmpty: shortVodController.isListEmpty.value,
                      displayNoMoreData:
                          shortVodController.displayNoMoreData.value,
                      displayLoading: shortVodController.displayLoading.value,
                      displayVideoCollectTimes: false,
                      noMoreWidget: ListNoMore(),
                      customScrollController:
                          shortVodController.scrollController,
                      displayCoverVertical: true,
                      onOverrideRedirectTap: (id) {
                        MyRouteDelegate.of(context).push(
                            AppRoutes.shortsByLocal,
                            args: {'itemId': 3, 'videoId': id});
                      }),
                ),
                //   SliverVodGrid(
                //       headerExtends: [
                //         SliverToBoxAdapter(
                //           child: FilterOptions(),
                //         ),
                //         const SliverToBoxAdapter(
                //           child: SizedBox(
                //             height: 10,
                //           ),
                //         )
                //       ],
                //       isListEmpty: shortVodController.isListEmpty.value,
                //       displayVideoCollectTimes: false,
                //       videos: shortVodController.vodList,
                //       displayNoMoreData:
                //           shortVodController.displayNoMoreData.value,
                //       displayLoading: shortVodController.displayLoading.value,
                //       noMoreWidget: ListNoMore(),
                //       displayCoverVertical: true,
                //       onOverrideRedirectTap: (id) {
                //         MyRouteDelegate.of(context).push(
                //             AppRoutes.shortsByLocal,
                //             args: {'itemId': 3, 'videoId': id});
                //       }),
                // ),

                if (_showSelectedBar)
                  FilterBar(
                    scrollController: shortVodController.scrollController!,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  TabBarHeaderDelegate(this.tabController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GSTabBar(
      controller: tabController,
      tabs: const ['長視頻', '短視頻'],
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant TabBarHeaderDelegate oldDelegate) {
    return false;
  }
}
