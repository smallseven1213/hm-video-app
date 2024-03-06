import 'package:get/get.dart';

import '../apis/navigation_api.dart';
import '../models/navigation.dart';

class NavigationController extends GetxController {
  var navigation = <Navigation>[].obs;
  // init
  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Navigation> response = await NavigationApi().getNavigation();
      navigation.value = response;
    } catch (e) {
      rethrow;
    }
  }
}
