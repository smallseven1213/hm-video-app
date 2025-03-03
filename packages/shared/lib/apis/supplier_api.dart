import 'package:get/get.dart';
import 'package:shared/models/supplier_with_vods.dart';

import '../controllers/system_config_controller.dart';
import '../models/block_vod.dart';
import '../models/supplier.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

class SupplierApi {
  static final SupplierApi _instance = SupplierApi._internal();

  SupplierApi._internal();

  factory SupplierApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/suppliers';

  // Get suppliers/supplier/?id=20 By id
  Future<Supplier> getOneSupplier(int id) async {
    var res = await fetcher(url: '$apiHost/api/v1/supplier/detail?id=$id');
    if (res.data['code'] != '00') {
      return Supplier();
    }
    return Supplier.fromJson(res.data['data']);
  }

  // Get /supplier/shortVideo?page=1&limit=100&id=20
  Future<BlockVod> getManyVideoBy({
    required int page,
    int limit = 100,
    required int id,
    int film = 2,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/supplier-latest-videos?page=$page&limit=$limit&id=$id&film=$film');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    return BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))
            .toList()),
        res.data['data']['total'] ?? limit * (page + 1));
  }

  // get PlayList from "GET" /suppliers/supplier/playlist?supplierId=20&videoId=605
  Future<List<Vod>> getPlayList({
    required int supplierId,
    required int videoId,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/area-short-videos?supplierId=$supplierId&videoId=$videoId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
  }

  Future<List<SupplierWithVod>> getManyPopularActorBy(
      {int page = 1, int limit = 10}) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/video/popular-supplier-videos?page=$page&limit=$limit');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data'] as List<dynamic>)
        .map((e) => SupplierWithVod(
              SupplierForVods.fromJson(e['supplier']),
              List.from((e['video'] as List<dynamic>)
                  .map((e) => Vod.fromJson(e))
                  .toList()),
            ))
        .toList());
  }

  // supplier/list?page
  Future<List<Supplier>> getManyBy({
    int page = 1,
    int limit = 10,
    String? name,
    int sortBy = 0,
    bool? isRecommend,
  }) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/supplier?page=$page&limit=$limit&name=$name&sortBy=$sortBy&isRecommend=$isRecommend');

    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Supplier.fromJson(e))
        .toList());
  }
}
