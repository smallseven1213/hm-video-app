import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/gift.dart';

class GiftsController extends GetxController {
  final liveApi = LiveApi();
  Rx<List<Gift>> gifts = Rx<List<Gift>>([]);

  @override
  void onInit() {
    super.onInit();
    fetchGifts();
  }

  void fetchGifts() async {
    try {
      var response = await liveApi.getGifts();
      gifts.value = response.data;
    } catch (e) {
      return;
    }
  }
}
