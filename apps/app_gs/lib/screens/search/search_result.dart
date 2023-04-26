import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/search_vod_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/fade_in_effect.dart';

import '../../widgets/list_no_more.dart';
import '../../widgets/no_data.dart';
import '../../widgets/sliver_video_preview_skelton_list.dart';
import '../../widgets/sliver_vod_grid.dart';
import '../../widgets/video_preview.dart';
import '../../widgets/video_preview_skelton_list.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return SliverVodGrid(
      videos: searchVodController.vodList,
      hasMoreData: searchVodController.hasMoreData.value,
      noMoreWidget: const ListNoMore(),
      scrollController: searchVodController.scrollController,
    );
  }
}
