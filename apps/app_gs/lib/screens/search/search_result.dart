import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/search_vod_controller.dart';
import 'package:shared/controllers/user_search_history_controller.dart';
import '../../widgets/list_no_more.dart';
import '../../widgets/sliver_vod_grid.dart';

final vodApi = VodApi();

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.keyword}) : super(key: key);

  final String keyword;

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final scrollController = ScrollController();
  late final SearchVodController searchVodController;

  @override
  void initState() {
    super.initState();
    searchVodController = SearchVodController(
      keyword: widget.keyword,
      scrollController: scrollController,
    );
    Get.find<UserSearchHistoryController>().add(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return SliverVodGrid(
      videos: searchVodController.vodList,
      hasMoreData: searchVodController.hasMoreData.value,
      noMoreWidget: ListNoMore(),
      customScrollController: searchVodController.scrollController,
    );
  }
}
