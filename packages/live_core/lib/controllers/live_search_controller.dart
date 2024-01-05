import 'package:get/get.dart';
import '../apis/search_api.dart';
import '../models/streamer_profile.dart';

final _searchApi = SearchApi();

class LiveSearchController extends GetxController {
  var fansRecommend = <StreamerProfile>[].obs;
  var popularStreamers = <StreamerProfile>[].obs;
  var recommendKeywords = <String>[].obs;
  var searchResult = <StreamerProfile>[].obs;

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

  void getKeywords(keyword) async {
    try {
      List<String> res = await _searchApi.getRecommendKeywords(keyword);
      recommendKeywords.value = res;
      print(res);
    } catch (e) {
      print(e);
    }
  }

  void search(keyword) async {
    try {
      List<StreamerProfile> res = await _searchApi.search(keyword: keyword);
      searchResult.value = res;
    } catch (e) {
      print(e);
    }
  }
}
