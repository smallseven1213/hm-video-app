import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../apis/vod_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final vodApi = VodApi();
const limit = 30;
final logger = Logger();

// 目前給Channel Block Style 3用
class ChannelBlockVodController extends BaseVodInfinityScrollController {
  final int areaId;
  RxInt film = 1.obs;
  var isError = false.obs;

  ChannelBlockVodController(
      {required this.areaId,
      required ScrollController scrollController,
      required bool autoDisposeScrollController,
      required bool hasLoadMoreEventWithScroller,
      bool loadDataOnInit = true})
      : super(
          loadDataOnInit: loadDataOnInit,
          customScrollController: scrollController,
          autoDisposeScrollController: autoDisposeScrollController,
          hasLoadMoreEventWithScroller: hasLoadMoreEventWithScroller,
        );

  @override
  Future<InfinityVod> fetchData(int page) async {
    try {
      var res = await vodApi.getVideoByAreaId(areaId, page: page, limit: limit);
      if (res != null && res.videos != null) {
        bool hasMoreData = res.videos!.total > limit * page;
        film.value = res.film;
        isError.value = false;
        return InfinityVod(res.videos!.vods, res.videos!.total, hasMoreData);
      } else {
        return InfinityVod([], 0, false);
      }
    } catch (e) {
      logger.e(e);
      isError.value = true;
      return InfinityVod([], 0, false);
    }
  }
}
