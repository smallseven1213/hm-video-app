import 'package:get/get.dart';
import 'package:live_core/utils/live_fetcher.dart';
import 'package:shared/controllers/system_config_controller.dart';

import '../models/streamer.dart';
import '../models/streamer_profile.dart';

const userApiHost = 'https://live-api.hmtech-dev.com/user/v1';

class SearchApi {
  static final SearchApi _instance = SearchApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  SearchApi._internal();

  factory SearchApi() {
    return _instance;
  }

  // 熱門推薦
  Future<List<StreamerProfile>> getPopularStreamers() async {
    var response = await liveFetcher(
      url: '$userApiHost/popular/streamers',
    );

    List<StreamerProfile> data = (response.data['data']['list'] as List)
        .map((item) => StreamerProfile.fromJson(item))
        .toList();

    return data;
  }

  // 粉絲推薦
  Future<List<StreamerProfile>> getFansRecommend() async {
    var response = await liveFetcher(
      url: '$userApiHost/fans/recommend',
    );

    List<StreamerProfile> data = (response.data['data']['list'] as List)
        .map((item) => StreamerProfile.fromJson(item))
        .toList();

    return data;
  }

  // 取得關鍵字列表
  Future<List<String>> getRecommendKeywords(keyword) async {
    var response = await liveFetcher(
      url: '$userApiHost/search/recommend?keyword=$keyword',
    );

    List<String> data = (response.data['data']['keywords'] as List)
        .map((item) => item.toString())
        .toList();

    return data;
  }

  // 搜尋
  Future<List<StreamerProfile>> search({
    String? keyword,
    int page = 1,
    int perPage = 20,
  }) async {
    var response = await liveFetcher(
      url:
          '$userApiHost/search/streamers?keyword=$keyword&page=$page&per_page=$perPage',
    );

    List<StreamerProfile> data =
        (response.data['data']['list']['items'] as List)
            .map((item) => StreamerProfile.fromJson(item))
            .toList();

    return data;
  }
}
