import 'package:get/get.dart';
import '../models/live_api_response_base.dart';
import '../apis/streamer_api.dart';
import '../models/streamer_rank.dart';

final _streamerApi = StreamerApi();

class StreamerRankController extends GetxController {
  Rx<List<StreamerRank>> streamerRanks = Rx<List<StreamerRank>>([]);

  StreamerRankController({
    RankType rankType = RankType.income,
    TimeType timeType = TimeType.today,
  }) {
    fetchData(rankType, timeType);
  }

  Future<void> fetchData(RankType rankType, TimeType timeType) async {
    try {
      List<StreamerRank> res = await _streamerApi.getStreamerRanking(
          rankType: rankType, timeType: timeType);
      streamerRanks.value = res;
    } catch (e) {
      print(e);
    }
  }
}
