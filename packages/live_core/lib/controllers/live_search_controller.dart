import 'package:get/get.dart';
import '../apis/search_api.dart';
import '../models/streamer_profile.dart';

final _searchApi = SearchApi();

class LiveSearchController extends GetxController {
  var fansRecommend = <StreamerProfile>[].obs;
  var popularStreamers = <StreamerProfile>[].obs;

  LiveSearchController() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<StreamerProfile> res = await _searchApi.getFansRecommend();
      List<StreamerProfile> res2 = await _searchApi.getPopularStreamers();

      fansRecommend.value = res;
      popularStreamers.value = res2;
    } catch (e) {
      print(e);
    }
  }

  // void updateRanking(RankType rankType, TimeType timeType) {
  //   fetchData(rankType, timeType);
  // }
}
