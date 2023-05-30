import 'package:flutter/material.dart';
import '../apis/vod_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final vodApi = VodApi();
const limit = 20;

class ChannelStyle3Controller extends BaseVodInfinityScrollController {
  final int tagId;

  ChannelStyle3Controller(
      {required this.tagId,
      required ScrollController scrollController,
      bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit, scrollController: scrollController);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res =
        await vodApi.getSameTagVod(page: page, tagId: tagId, limit: limit);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
