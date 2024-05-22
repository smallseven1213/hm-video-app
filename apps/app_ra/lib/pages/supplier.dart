import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_short_controller.dart';
import 'package:shared/controllers/supplier_video_controller.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/supplier/card.dart';
import '../screens/supplier/list.dart';
import '../widgets/list_no_more.dart';
import '../widgets/ra_tab_bar.dart';
import '../widgets/sliver_vod_grid.dart';

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

        if (_tabController.index == 0) {
          shortVideoController.reset();
          shortVideoController.loadMoreData();
        } else {
          supplierVideoController.reset();
          supplierVideoController.loadMoreData();
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _parentScrollController.dispose();
    shortVideoController.dispose();
    supplierVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Stack(
      children: [
        NestedScrollView(
            controller: _parentScrollController,
            physics: kIsWeb ? null : const BouncingScrollPhysics(),
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
              physics: kIsWeb ? null : const BouncingScrollPhysics(),
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollEndNotification &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        _tabController.index == 0) {
                      shortVideoController.loadMoreData();
                    }
                    return false;
                  },
                  child: Obx(() => SupplierVods(
                        id: widget.id,
                        videos: shortVideoController.vodList,
                        displayLoading:
                            shortVideoController.displayLoading.value,
                        displayNoMoreData:
                            shortVideoController.displayNoMoreData.value,
                        isListEmpty: shortVideoController.isListEmpty.value,
                      )),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollEndNotification &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        _tabController.index == 1) {
                      supplierVideoController.loadMoreData();
                    }
                    return false;
                  },
                  child: Obx(() => SliverVodGrid(
                      key: const Key('supplier_short'),
                      videos: supplierVideoController.vodList.value,
                      displayLoading:
                          supplierVideoController.displayLoading.value,
                      displayNoMoreData:
                          supplierVideoController.displayNoMoreData.value,
                      isListEmpty: supplierVideoController.isListEmpty.value,
                      noMoreWidget: ListNoMore(),
                      displayVideoFavoriteTimes: false,
                      onScrollEnd: () {
                        supplierVideoController.loadMoreData();
                      })),
                ),
              ],
            )),
        const FloatPageBackButton()
      ],
    ));
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
    return RATabBar(
      controller: tabController,
      tabs: const ['短片', '長片'],
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
