import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GameConfigController extends GetxController {
  var switchPaymentPage = 0.obs;
  var gamePageColor = 1;

  GetStorage box = GetStorage();

  @override
  void onReady() {
    super.onReady();

    if (box.read('pageColor') != null) {
      gamePageColor = box.read('pageColor');
    }

    _getGameConfig();
  }

  _getGameConfig() async {
    try {
      var res = await Get.put(GameLobbyApi()).getGameConfig();
      switchPaymentPage.value = res.paymentPage;
      gamePageColor = res.pageColor;

      if (box.read('pageColor') == null) {
        box.write('pageColor', gamePageColor);
      }

      print('switchPaymentPage: $switchPaymentPage');
    } catch (e) {
      print('_getGameConfig error: $e');
    }
  }
}

Map<String, int> switchPaymentPageType = {
  'polling': 1,
  'list': 2,
};
