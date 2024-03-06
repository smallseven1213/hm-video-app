import 'package:get/get.dart';
import '../apis/search_api.dart';
import '../models/streamer_profile.dart';

final _searchApi = SearchApi();

class LiveSearchController extends GetxController {
  var fansRecommend = <StreamerProfile>[].obs;
  var popularStreamers = <StreamerProfile>[].obs;
  var recommendKeywords = <String>[].obs;
  var searchResult = <StreamerProfile>[].obs;
  var keyword = ''.obs;

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
      return;
    }
  }

  void getKeywords(text) async {
    try {
      if (text.isEmpty) {
        recommendKeywords.value = [];
        return;
      }
      List<String> res = await _searchApi.getRecommendKeywords(text);
      recommendKeywords.value = res;
    } catch (e) {
      return;
    }
  }

  void search(text) async {
    searchResult.value = [];
    try {
      List<StreamerProfile> res = await _searchApi.search(keyword: text);
      searchResult.value = res;
      keyword.value = text;
    } catch (e) {
      return;
    }
  }

  void clearSearchResult() {
    keyword.value = '';
    searchResult.value = [];
  }
}
