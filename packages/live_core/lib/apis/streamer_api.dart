import 'package:get/get.dart';
import 'package:live_core/utils/live_fetcher.dart';
import 'package:shared/controllers/system_config_controller.dart';

import '../models/live_api_response_base.dart';
import '../models/streamer_rank.dart';

const userApiHost = 'https://live-api.hmtech-dev.com/user/v1';

class StreamerApi {
  static final StreamerApi _instance = StreamerApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  StreamerApi._internal();

  factory StreamerApi() {
    return _instance;
  }

  // 主播排行榜
  Future<List<StreamerRank>> getStreamerRanking({
    RankType rankType = RankType.income,
    TimeType timeType = TimeType.today,
  }) async {
    var response = await liveFetcher(
      url:
          '$userApiHost/streamer/ranking?rank_type=${rankType.index}&time_type=${timeType.index}',
    );

    if (response.data['data'].isEmpty) {
      return [];
    }

    List<StreamerRank> data = (response.data['data'] as List)
        .map((item) => StreamerRank.fromJson(item))
        .toList();

    return data;
  }

  // 關注
  Future<LiveApiResponseBase> follow(int streamerId) async {
    var response = await liveFetcher(
      url: '$userApiHost/streamer/follow',
      method: 'POST',
      body: {
        'streamer_id': streamerId,
      },
    );

    LiveApiResponseBase parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data,
    );

    return parsedResponse;
  }

  // 取消關注
  Future<LiveApiResponseBase> unfollow(int streamerId) async {
    var response = await liveFetcher(
      url: '$userApiHost/streamer/unfollow',
      method: 'POST',
      body: {
        'streamer_id': streamerId,
      },
    );

    LiveApiResponseBase parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data,
    );

    return parsedResponse;
  }
}
