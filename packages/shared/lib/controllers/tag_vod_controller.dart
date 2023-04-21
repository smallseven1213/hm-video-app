import 'package:flutter/material.dart';
import 'package:shared/apis/tag_api.dart';
import '../apis/vod_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final vodApi = VodApi();
const limit = 100;

class TagVodController extends BaseVodInfinityScrollController {
  final int tagId;

  TagVodController(
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
