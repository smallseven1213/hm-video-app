import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/search_vod_controller.dart';
import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';

final vodApi = VodApi();

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.keyword}) : super(key: key);

  final String keyword;

  @override
  SearchResultPageState createState() => SearchResultPageState();
}

class SearchResultPageState extends State<SearchResultPage> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();
  late final SearchVodController searchVodController;

  @override
  void initState() {
    super.initState();
    searchVodController = SearchVodController(
      keyword: widget.keyword,
      scrollController: scrollController,
    );
  }

  // dispose scrollController
  @override
  void dispose() {
    searchVodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SliverVodGrid(
          isListEmpty: searchVodController.isListEmpty.value,
          displayVideoCollectTimes: false,
          videos: searchVodController.vodList,
          displayNoMoreData: searchVodController.displayNoMoreData.value,
          displayLoading: searchVodController.displayLoading.value,
          noMoreWidget: ListNoMore(),
        ));
  }
}
