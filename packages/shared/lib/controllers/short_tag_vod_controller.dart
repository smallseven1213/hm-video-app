import 'package:flutter/material.dart';
import 'package:shared/apis/tag_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final tagApi = TagApi();
const limit = 21;

class ShortTagVodController extends BaseVodInfinityScrollController {
  final int tagId;

  ShortTagVodController(
      {required this.tagId,
      ScrollController? scrollController,
      bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit,
            customScrollController: scrollController);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res =
        await tagApi.getShortVideoByTagId(page: page, id: tagId, limit: limit);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
