import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';

class GamePlatformConfigController extends GetxController {
  var switchPaymentPage = 0.obs;
  var gamePageColor = 0.obs;
  var isShowEnvelope = false.obs;
  var isOpenThirdPartyGame = false.obs;
  var thirdPartyGameId = ''.obs;
  var thirdPartyGameTpCode = ''.obs;
  var gameTypeIndex = 0.obs;
  var videoToGameRoute = ''.obs;

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

  void setThirdPartyGame(bool status, String gameId, String tpCode) {
    isOpenThirdPartyGame.value = status;
    thirdPartyGameId.value = gameId.toString();
    thirdPartyGameTpCode.value = tpCode.toString();
  }

  void setGameTypeIndex(int index) {
    gameTypeIndex.value = index;
  }

  void setSwitchPaymentPage(int type) {
    switchPaymentPage.value = type;
  }

  void setVideoToGameRoute(String route) {
    videoToGameRoute.value = route;
  }
}

Map<String, int> switchPaymentPageType = {
  'polling': 1,
  'list': 2,
};
