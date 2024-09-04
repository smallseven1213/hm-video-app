import 'package:app_wl_id1/widgets/sliver_post_grid.dart';
import 'package:app_wl_id1/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/channel_post_controller.dart';
import 'package:shared/controllers/games_controller.dart';
import 'package:shared/controllers/search_temp_controller.dart';
import 'package:shared/controllers/search_vod_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';
import '../../widgets/tab_bar.dart';
import 'games_result.dart';

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
  late final GamesController gamesController;
  late final ChannelPostController postController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    searchVodController = SearchVodController(keyword: widget.keyword, film: 1);
    searchShortController =
        SearchVodController(keyword: widget.keyword, film: 2);
    gamesController = GamesController(
      name: widget.keyword,
      scrollController: scrollController,
    );
    postController = ChannelPostController(
      keyword: widget.keyword,
      scrollController: scrollController,
      limit: 10,
    );

    searchShortController.vodList.listen((p0) {
      searchTempShortController.replaceVideos(p0);
    });
  }

  // dispose scrollController
  @override
  void dispose() {
    _tabController.dispose();
    searchVodController.dispose();
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GSTabBar
        GSTabBar(
          controller: _tabController,
          tabs: [I18n.longVideo, I18n.shortVideo, I18n.game,I18n.post],
        ),
        // SliverVodGrid
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: kIsWeb ? null : const BouncingScrollPhysics(),
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (_tabController.index == 0 &&
                      scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    searchVodController.loadMoreData();
                  }
                  return false;
                },
                child: Obx(() => SliverVodGrid(
                      videos: searchVodController.vodList.value,
                      displayLoading: searchVodController.isLoading.value,
                      displayNoMoreData:
                          searchVodController.displayNoMoreData.value,
                      isListEmpty: searchVodController.isListEmpty.value,
                      noMoreWidget: ListNoMore(),
                      displayVideoFavoriteTimes: false,
                    )),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (_tabController.index == 1 &&
                      scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    searchShortController.loadMoreData();
                  }
                  return false;
                },
                child: Obx(() => SliverVodGrid(
                    film: 2,
                    isListEmpty: searchShortController.isListEmpty.value,
                    displayVideoFavoriteTimes: false,
                    videos: searchShortController.vodList.value,
                    displayNoMoreData:
                        searchShortController.displayNoMoreData.value,
                    displayLoading: searchShortController.displayLoading.value,
                    noMoreWidget: ListNoMore(),
                    displayCoverVertical: true,
                    onOverrideRedirectTap: (id) {
                      MyRouteDelegate.of(context).push(AppRoutes.shortsByLocal,
                          args: {'itemId': 3, 'videoId': id});
                    })),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (_tabController.index == 1 &&
                      scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    gamesController.loadMoreData();
                  }
                  return false;
                },
                child: GamesResult(
                  scrollController: scrollController,
                  gamesController: gamesController,
                ),
              ),
              Obx(() => SliverPostGrid(
                    posts: postController.postList,
                    isError: postController.isError.value,
                    isListEmpty: postController.isListEmpty.value,
                    displayLoading: postController.displayLoading.value,
                    displayNoMoreData: postController.displayNoMoreData.value,
                    onReload: postController.pullToRefresh,
                    onScrollEnd: postController.loadMoreData,
                    customScrollController: scrollController,
                    vertical: false,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
