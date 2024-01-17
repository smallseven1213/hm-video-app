// 儲存使用者搜尋紀錄(keyword Array)的Getx Controller

import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LiveSearchHistoryController extends GetxController {
  var searchHistory = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();
    var box = await Hive.openBox<String>('liveSearchHistoryBox');
    searchHistory.addAll(box.values.toList().reversed);
  }

  void add(String keyword) async {
    var box = await Hive.openBox<String>('liveSearchHistoryBox');

    if (keyword.length > 8) {
      keyword = keyword.substring(0, 8);
    }

    if (!box.values.contains(keyword)) {
      if (searchHistory.contains(keyword)) {
        searchHistory.remove(keyword);
      }
      searchHistory.insert(0, keyword);
      box.add(keyword);
    }
  }

  void remove(String keyword) async {
    searchHistory.remove(keyword);
    var box = await Hive.openBox<String>('liveSearchHistoryBox');
    int index = box.values.toList().indexOf(keyword);
    if (index != -1) {
      box.deleteAt(index);
    }
  }

  void clear() async {
    searchHistory.clear();
    var box = await Hive.openBox<String>('liveSearchHistoryBox');
    box.clear();
  }

  @override
  void onClose() async {
    var box = await Hive.openBox<String>('liveSearchHistoryBox');
    await box.close();
    super.onClose();
  }
}
