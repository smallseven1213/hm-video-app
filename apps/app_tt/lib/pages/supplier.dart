import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_short_controller.dart';
import 'package:shared/controllers/supplier_video_controller.dart';

import 'package:shared/models/supplier.dart';
import 'package:shared/modules/supplier/supplier_consumer.dart';
import 'package:shared/modules/supplier/supplier_provider.dart';

import '../screens/supplier/follow_with_recommendations.dart';
import '../screens/supplier/header.dart';
import '../screens/supplier/list.dart';
import '../widgets/list_no_more.dart';
import '../widgets/statistic_item.dart';
import '../widgets/sliver_vod_grid.dart';

class SupplierPage extends StatefulWidget {
  final int id;
  const SupplierPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  SupplierPageState createState() => SupplierPageState();
}

class SupplierPageState extends State<SupplierPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _parentScrollController;
  late final SupplierShortController shortVideoController;
  late final SupplierVideoController supplierVideoController;

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
    return SupplierProvider(
      id: widget.id,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/user-bg.webp'),
            ),
            NestedScrollView(
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
                        color: Colors.white,
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
                              children: [
                                StatisticsItem(
                                  count: supplier.collectTotal ?? 0,
                                  label: '讚數',
                                ),
                                const SizedBox(width: 20),
                                StatisticsItem(
                                  count: supplier.followTotal ?? 0,
                                  label: '關注',
                                ),
                                const SizedBox(width: 20),
                                StatisticsItem(
                                  count: supplier.shortVideoTotal ?? 0,
                                  label: '短視頻',
                                ),
                                const SizedBox(width: 20),
                                StatisticsItem(
                                  count: supplier.videoCount ?? 0,
                                  label: '長視頻',
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
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Container(
                    color: Colors.white,
                    child: NotificationListener<ScrollNotification>(
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
                  ),
                  Container(
                    color: Colors.white,
                    child: NotificationListener<ScrollNotification>(
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
                          padding: 2,
                          videos: supplierVideoController.vodList,
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
                  ),
                ],
              ),
            ),
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
    return Container(
      height: 60,
      color: Colors.white,
      child: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: const Color(0xFF73747b),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Color(0xFF161823), // 这里是你想要的颜色
              width: 2.0, // 这是下划线的宽度，可以根据需要进行调整
            ),
          ),
          tabs: const [
            // Tab(text: '貼文'),
            Tab(text: '短視頻'),
            Tab(text: '長視頻'),
          ]),
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
