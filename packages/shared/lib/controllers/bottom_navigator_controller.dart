import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/navigator_api.dart';
import '../models/navigation.dart';

final logger = Logger();

class BottonNavigatorController extends GetxController {
  final activeKey = ''.obs;
  final navigatorItems = <Navigation>[].obs;

  @override
  void onInit() {
    super.onInit();
    NavigatorApi().getNavigations().then((value) {
      setNavigatorItems(value);
      changeKey(value.first.path!);
    });
  }

  void changeKey(String key) {
    activeKey.value = key;
  }

  void setNavigatorItems(List<Navigation> items) {
    navigatorItems.value = items;
  }
}
