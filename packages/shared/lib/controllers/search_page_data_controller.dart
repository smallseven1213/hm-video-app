import 'package:get/get.dart';

class SearchPageDataController extends GetxController {
  var keyword = ''.obs;

  void setKeyword(String keywordValue) {
    keyword.value = keywordValue;
  }
}
