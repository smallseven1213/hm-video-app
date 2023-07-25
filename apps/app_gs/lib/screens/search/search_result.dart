import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/search_temp_controller.dart';
import 'package:shared/controllers/search_vod_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';
import '../../widgets/tab_bar.dart';

final vodApi = VodApi();

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.keyword}) : super(key: key);

  final String keyword;

  @override
  SearchResultPageState createState() => SearchResultPageState();
}

class SearchResultPageState extends State<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final scrollController = ScrollController();
  final searchTempShortController = Get.find<SearchTempShortController>();
  late final SearchVodController searchVodController;
  late final SearchVodController searchShortController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    searchVodController = SearchVodController(
        keyword: widget.keyword, scrollController: scrollController, film: 1);
    searchShortController = SearchVodController(
        keyword: widget.keyword, scrollController: scrollController, film: 2);

    searchShortController.vodList.listen((p0) {
      searchTempShortController.replaceVideos(p0);
    });
  }

  // dispose scrollController
  @override
  void dispose() {
    _tabController.dispose();
    searchVodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GSTabBar
        GSTabBar(
          controller: _tabController,
          tabs: const [
            '長視頻',
            '短視頻',
          ],
        ),
        // SliverVodGrid
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Obx(() => SliverVodGrid(
                    isListEmpty: searchVodController.isListEmpty.value,
                    displayVideoCollectTimes: false,
                    videos: searchVodController.vodList,
                    displayNoMoreData:
                        searchVodController.displayNoMoreData.value,
                    displayLoading: searchVodController.displayLoading.value,
                    noMoreWidget: ListNoMore(),
                  )),
              Obx(() => SliverVodGrid(
                  isListEmpty: searchShortController.isListEmpty.value,
                  displayVideoCollectTimes: false,
                  videos: searchShortController.vodList,
                  displayNoMoreData:
                      searchShortController.displayNoMoreData.value,
                  displayLoading: searchShortController.displayLoading.value,
                  noMoreWidget: ListNoMore(),
                  displayCoverVertical: true,
                  onOverrideRedirectTap: (id) {
                    MyRouteDelegate.of(context).push(AppRoutes.shortsByLocal,
                        args: {'itemId': 3, 'videoId': id});
                  })),
            ],
          ),
        ),
      ],
    );
  }
}
