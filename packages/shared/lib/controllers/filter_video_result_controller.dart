import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/publisher_api.dart';
import '../apis/region_api.dart';
import '../apis/vod_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';
import 'filter_video_screen_controller.dart';

final logger = Logger();
final vodApi = VodApi();
final regionApi = RegionApi();
final publisherApi = PublisherApi();

const limit = 20;

class FilterVideoScreenResultController
    extends BaseVodInfinityScrollController {
  FilterVideoScreenResultController(
      {required ScrollController scrollController, bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit,
            customScrollController: scrollController);

  @override
  Future<InfinityVod> fetchData(int page) async {
    List<String> queryItems = [];

    var selectedOptions =
        Get.find<FilterVideoScreenController>().selectedOptions;

    selectedOptions.forEach((key, values) {
      if (values.isNotEmpty && values.first != 0) {
        String valueString = values.map((value) => value.toString()).join(',');
        queryItems.add('$key=$valueString');
      }
    });

    String queryString = queryItems.join('&');
    logger.i(queryString);

    var res = await vodApi.getSimpleManyBy(
        page: page, limit: limit, queryString: queryString, film: 1);
    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
