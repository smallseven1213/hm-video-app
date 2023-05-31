import 'package:flutter/material.dart';
import '../apis/supplier_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final supplierApi = SupplierApi();
const limit = 20;

class SupplierVodController extends BaseVodInfinityScrollController {
  final int supplierId;

  SupplierVodController(
      {required this.supplierId, required ScrollController scrollController})
      : super(customScrollController: scrollController);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await supplierApi.getManyShortVideoBy(
        page: page, id: supplierId, limit: limit);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
