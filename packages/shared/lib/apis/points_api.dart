import 'package:shared/models/block_vod.dart';
import 'package:shared/models/user_purchase_record.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';

import '../models/vod.dart';

final systemConfig = SystemConfig();

class PointApi {
  static final PointApi _instance = PointApi._internal();

  PointApi._internal();

  factory PointApi() {
    return _instance;
  }

  Future<BlockVod> getManyBy() async {
    var url =
        '${systemConfig.apiHost}/public/points/purchase-record/list/video';
    var value = await fetcher(url: url);
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods =
        List.from((res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(vods, vods.length);
  }

  Future<List<UserPurchaseRecord>> getPoints(
      {int limit = 100, int page = 1}) async {
    var url =
        '${systemConfig.apiHost}/public/points/purchase-record/list?page=$page&limit=$limit';
    var value = await fetcher(url: url);
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }
    return List.from((res['data']['data'] as List<dynamic>)
        .map((e) => UserPurchaseRecord.fromJson(e)));
  }
}
