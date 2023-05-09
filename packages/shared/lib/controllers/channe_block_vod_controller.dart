import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../apis/vod_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final vodApi = VodApi();
const limit = 20;
final logger = Logger();

// 目前給Channel Block Style 3用
class ChannelBlockVodController extends BaseVodInfinityScrollController {
  final int areaId;

  ChannelBlockVodController(
      {required this.areaId,
      required ScrollController scrollController,
      bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit, scrollController: scrollController);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await vodApi.getVideoByAreaId(areaId, page: page, limit: limit);

    bool hasMoreData = res.total > limit * page;
    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
