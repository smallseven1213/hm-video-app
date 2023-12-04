import 'package:get/get.dart';

import '../apis/user_api.dart';

class GiftsController extends GetxController {
  final userApi = UserApi();
  Rx<dynamic> gifts = Rx<dynamic>(null);

  @override
  void onInit() {
    super.onInit();
    fetchGifts();
  }

  void fetchGifts() async {
    try {
      gifts.value = await userApi.getGifts();
    } catch (e) {
      print(e);
    }
  }
}
