import 'package:flutter/material.dart';

import '../apis/vod_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final vodApi = VodApi();
const int limit = 16;

class BlockVodController extends BaseVodInfinityScrollController {
  final int areaId;

  BlockVodController(
      {required this.areaId,
      required ScrollController scrollController,
      bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit,
            customScrollController: scrollController);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await vodApi.getMoreMany(areaId, page: page, limit: limit);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
