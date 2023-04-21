import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../apis/actor_api.dart';
import '../apis/publisher_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final publisherApi = PublisherApi();
final logger = Logger();
const limit = 100;

class PublisherLatestVodController extends BaseVodInfinityScrollController {
  final int publisherId;

  PublisherLatestVodController(
      {required this.publisherId,
      required ScrollController scrollController,
      bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit, scrollController: scrollController);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await publisherApi.getManyLatestVodBy(
        page: page, publisherId: publisherId, limit: limit);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
