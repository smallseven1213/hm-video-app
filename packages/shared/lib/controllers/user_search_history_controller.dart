// 儲存使用者搜尋紀錄(keyword Array)的Getx Controller

import 'package:get/get.dart';

class UserSearchHistoryController extends GetxController {
  var searchHistory = <String>[].obs;

  void add(String keyword) {
    if (searchHistory.contains(keyword)) {
      searchHistory.remove(keyword);
    }
    searchHistory.insert(0, keyword);
  }

  void remove(String keyword) {
    searchHistory.remove(keyword);
  }

  void clear() {
    searchHistory.clear();
  }
}
