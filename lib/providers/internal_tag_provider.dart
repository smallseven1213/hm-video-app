import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class InternalTagProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl =
        '${AppController.cc.endpoint.getApi()}/public/internalTags';
    super.onInit();
  }

  Future<BlockVod> getRecommendVod({
    int? tagId,
    int? vodId,
    List<int>? tagIds,
    int page = 1,
    int limit = 100,
  }) async {
    var url = '/internalTag/views?page=$page&limit=$limit&';
    if (tagIds?.isNotEmpty == true && vodId != null) {
      url = '${url}internalTagId=${(tagIds ?? []).join(',')}&excludeId=$vodId';
    } else {
      if (tagId != null && tagId != 0) {
        url = '${url}internalTagId=$tagId&';
      }
      if (vodId != null) {
        url = '${url}excludeId=$vodId';
      }
      if ((tagId == null || tagId == 0) && vodId == null) {
        url = '${url}internalTagId=&excludeId=';
      }
    }
    // print(url);
    var value = await get(url);
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods =
        List.from((res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(vods, vods.length);
  }
}
