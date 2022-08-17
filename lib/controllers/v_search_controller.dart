import 'package:get/get.dart';

class VSearchController extends GetxController {
  List<String> history = [];

  void addKeyword(String keyword) {
    history.removeWhere((e) {
      return e.contains(keyword);
    });
    history.insert(0, keyword);
    update();
  }

  void clearKeywords() {
    history.clear();
    update();
  }

  List<String> getKeywords() {
    return history;
  }
}
