import 'package:get/get.dart';

import '../apis/ad_api.dart';
import '../apis/live_api.dart';
import '../models/ad.dart';

final liveApi = LiveApi();

class AdController extends GetxController {
  var ads = <Ad>[].obs;
  // init
  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Ad> response = await AdApi().getBanners();
      ads.value = response;
    } catch (e) {
      print(e);
    }
  }

  Future<void> recordAdClick(int id) async {
    try {
      await AdApi().recordAdClick(id);
    } catch (e) {
      print(e);
    }
  }
}
