import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/position.dart';
import '../shard.dart';

class PositionProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.timeout = const Duration(minutes: 1);
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/banners';
    super.onInit();
  }

  Future<List<Position>> getManyBy({
    int positionId = 1,
  }) async {
    var value = await get('/banner/position?positionId=$positionId');
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }
    return List.from(
        (res['data'] as List<dynamic>).map((e) => Position.fromJson(e)));
  }

  Future<bool> putManyBy({
    int positionId = 1,
  }) async {
    var value = await get('/banner/position?positionId=$positionId');
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return SharedPreferencesUtil.setPositions(positionId, []);
    }
    return SharedPreferencesUtil.setPositions(positionId, res['data']);
  }

  Future<void> addBannerClickRecord(int bannerId) async {
    if (bannerId == 0) return;

    post('/banner/bannerClickRecord', {'bannerId': bannerId});
  }
}
