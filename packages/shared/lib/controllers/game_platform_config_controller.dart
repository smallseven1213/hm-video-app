import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';

class GamePlatformConfigController extends GetxController {
  var switchPaymentPage = 0.obs;
  var gamePageColor = 0.obs;
  var isShowEnvelope = false.obs;
  var isOpenThirdPartyGame = false.obs;
  var thirdPartyGameId = ''.obs;

  Future<void> fetchData() async {
    GameLobbyApi gameLobbyApi = GameLobbyApi();
    var result = await gameLobbyApi.getGamePlatformConfig();
    switchPaymentPage.value = result.paymentPage;
    isShowEnvelope.value = result.distributed;
    gamePageColor.value = result.pageColor;
  }

  void setEnvelopeStatus(bool status) {
    isShowEnvelope.value = status;
  }

  void setThirdPartyGame(bool status, String? gameId) {
    isOpenThirdPartyGame.value = status;
    thirdPartyGameId.value = gameId.toString();
  }
}

Map<String, int> switchPaymentPageType = {
  'polling': 1,
  'list': 2,
};
