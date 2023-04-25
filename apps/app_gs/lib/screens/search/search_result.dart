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
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return CustomScrollView(
            controller: searchVodController.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverAlignedGrid.count(
                  crossAxisCount: 2,
                  itemCount: searchVodController.vodList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var video = searchVodController.vodList[index];
                    return VideoPreviewWidget(
                        id: video.id,
                        coverVertical: video.coverVertical!,
                        coverHorizontal: video.coverHorizontal!,
                        timeLength: video.timeLength!,
                        tags: video.tags!,
                        title: video.title,
                        videoViewTimes: video.videoViewTimes!);
                  },
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 10.0,
                ),
              ),
              if (searchVodController.hasMoreData.value)
                const SliverVideoPreviewSkeletonList(),
              if (searchVodController.showNoMore.value)
                const SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          );
        }));
  }
}
