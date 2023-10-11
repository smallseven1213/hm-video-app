import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

final GameLobbyApi gameLobbyApi = GameLobbyApi();
final logger = Logger();

class GameConfigController extends GetxController {
  var switchPaymentPage = 0.obs;
  var gamePageColor = 1;
  var isShowEnvelope = false.obs;

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
      var res = await gameLobbyApi.getGameConfig();
      switchPaymentPage.value = res.paymentPage;
      isShowEnvelope.value = res.distributed;
      gamePageColor = res.pageColor;

      if (box.read('pageColor') == null) {
        box.write('pageColor', gamePageColor);
      }

      logger.i('switchPaymentPage: $switchPaymentPage');
    } catch (e) {
      logger.i('_getGameConfig error: $e');
    }
  }

  void setEnvelopeStatus(bool status) {
    isShowEnvelope.value = status;
  }
}

Map<String, int> switchPaymentPageType = {
  'polling': 1,
  'list': 2,
};
