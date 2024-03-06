import 'package:get/get.dart';
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

  Future<void> fetchData(
    RankType rankType,
    TimeType timeType,
  ) async {
    try {
      List<StreamerRank> res = await _streamerApi.getStreamerRanking(
          rankType: rankType, timeType: timeType);
      streamerRanks.value = res;
      streamerRanks.refresh();
    } catch (e) {
      // print(e);
    }
  }

  void updateRanking(RankType rankType, TimeType timeType) {
    fetchData(rankType, timeType);
  }
}
