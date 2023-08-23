import 'package:get/get.dart';

class PageViewIndexController extends GetxController {
  RxMap<String, int> pageIndexes = <String, int>{}.obs;

  void setPageIndex(String pageId, int index) {
    pageIndexes[pageId] = index;
  }

  int getPageIndex(String pageId) {
    return pageIndexes[pageId] ?? 0;
  }
}
