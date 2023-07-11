import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_short_controller.dart';
import 'package:shared/controllers/supplier_video_controller.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/supplier/card.dart';
import '../screens/supplier/list.dart';
import '../widgets/list_no_more.dart';
import '../widgets/no_data.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/sliver_vod_grid.dart';
import '../widgets/tab_bar.dart';

class SupplierPage extends StatefulWidget {
  final int id;

  const SupplierPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late ScrollController _parentScrollController;
  late final SupplierShortController shortVideoController;
  late final SupplierVideoController supplierVideoController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _parentScrollController = ScrollController();
    _tabController = TabController(vsync: this, length: 2);
    shortVideoController = SupplierShortController(
        supplierId: widget.id, scrollController: _parentScrollController);
    supplierVideoController = SupplierVideoController(
        supplierId: widget.id, scrollController: _parentScrollController);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _parentScrollController.jumpTo(0.0);
      }
    });
  }

  @override
  void dispose() {
    _parentScrollController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         Obx(() => CustomScrollView(
  //               controller: vodController.scrollController,
  //               physics: const BouncingScrollPhysics(),
  //               slivers: [
  // SliverToBoxAdapter(
  //   child: SizedBox(
  //     height: MediaQuery.of(context).padding.top,
  //   ),
  // ),
  // SupplierCard(id: widget.id),
  //                 SupplierVods(id: widget.id, vodList: vodController.vodList),
  //                 if (vodController.isListEmpty.value)
  //                   const SliverToBoxAdapter(
  //                     child: NoDataWidget(),
  //                   ),
  //                 if (vodController.displayLoading.value)
  //                   // ignore: prefer_const_constructors
  //                   SliverVideoPreviewSkeletonList(),
  //                 if (vodController.displayNoMoreData.value)
  //                   SliverToBoxAdapter(
  //                     child: ListNoMore(),
  //                   )
  //               ],
  //             )),
  //         const FloatPageBackButton()
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body: Obx(() {
      return Stack(
        children: [
          NestedScrollView(
              controller: _parentScrollController,
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // 返回一个 Sliver 数组给外部可滚动组件。
                return <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  ),
                  SupplierCard(id: widget.id),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: TabBarHeaderDelegate(_tabController),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  SupplierVods(
                    id: widget.id,
                    videos: shortVideoController.vodList,
                    displayLoading:
                        supplierVideoController.displayLoading.value,
                    displayNoMoreData:
                        supplierVideoController.displayNoMoreData.value,
                    isListEmpty: supplierVideoController.isListEmpty.value,
                  ),
                  SliverVodGrid(
                      key: const Key('supplier_short'),
                      videos: supplierVideoController.vodList,
                      displayLoading:
                          supplierVideoController.displayLoading.value,
                      displayNoMoreData:
                          supplierVideoController.displayNoMoreData.value,
                      isListEmpty: supplierVideoController.isListEmpty.value,
                      noMoreWidget: ListNoMore(),
                      usePrimaryParentScrollController: true,
                      displayVideoCollectTimes: false,
                      onScrollEnd: () {
                        supplierVideoController.loadMoreData();
                      }),
                ],
              )),
          const FloatPageBackButton()
        ],
      );
    }));
  }

  @override
  bool get wantKeepAlive => true;
}

class TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  TabBarHeaderDelegate(this.tabController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GSTabBar(
      controller: tabController,
      tabs: const ['短視頻', '長視頻'],
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
