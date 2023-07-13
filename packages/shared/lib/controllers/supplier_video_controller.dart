import 'package:flutter/material.dart';
import '../apis/supplier_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final supplierApi = SupplierApi();
const limit = 20;

class SupplierVideoController extends BaseVodInfinityScrollController {
  final int supplierId;

  SupplierVideoController(
      {required this.supplierId, required ScrollController scrollController})
      : super(
            customScrollController: scrollController,
            hasLoadMoreEventWithScroller: false,
            autoDisposeScrollController: false);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await supplierApi.getManyVideoBy(
        page: page, id: supplierId, limit: limit, film: 1);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
