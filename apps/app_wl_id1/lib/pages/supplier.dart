import 'package:app_wl_id1/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_short_controller.dart';
import 'package:shared/controllers/supplier_video_controller.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/supplier/supplier_consumer.dart';
import 'package:shared/modules/supplier/supplier_provider.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/supplier/follow_with_recommendations.dart';
import '../screens/supplier/header.dart';
import '../screens/supplier/list.dart';
import '../widgets/list_no_more.dart';
import '../widgets/sliver_vod_grid.dart';
import '../widgets/statistic_item.dart';
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
    return SupplierProvider(
        id: widget.id,
        child: Scaffold(
            body: Stack(
          children: [
            NestedScrollView(
                controller: _parentScrollController,
                physics: kIsWeb ? null : const BouncingScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: SupplierHeader(context: context, id: widget.id),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: SupplierConsumer(
                          id: widget.id,
                          child: (Supplier supplier) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StatisticsItem(
                                    count: supplier.collectTotal ?? 0,
                                    label: I18n.countLikes,
                                  ),
                                  StatisticsItem(
                                    count: supplier.followTotal ?? 0,
                                    label: I18n.followStatus,
                                  ),
                                  StatisticsItem(
                                    count: supplier.shortVideoTotal ?? 0,
                                    label: I18n.shortVideo,
                                  ),
                                  StatisticsItem(
                                    count: supplier.videoCount ?? 0,
                                    label: I18n.longVideo,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                supplier.description ?? '',
                                softWrap: true,
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              FollowWithRecommendations(
                                  id: widget.id, supplier: supplier),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                          isListEmpty:
                              supplierVideoController.isListEmpty.value,
                          noMoreWidget: ListNoMore(),
                          displayVideoCollectTimes: false,
                          onScrollEnd: () {
                            supplierVideoController.loadMoreData();
                          })),
                    ),
                  ],
                )),
            const FloatPageBackButton()
          ],
        )));
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
      tabs: [I18n.shortVideo, I18n.longVideo],
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
