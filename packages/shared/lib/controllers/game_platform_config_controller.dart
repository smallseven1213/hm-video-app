import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GamePlatformConfigController extends GetxController {
  var switchPaymentPage = 0.obs; // 存款頁面切換
  var gamePageColor = 0.obs; // 遊戲大廳theme
  var isShowEnvelope = false.obs; // 遊戲大廳是否顯示紅包
  var isOpenThirdPartyGame = false.obs; // 是否開啟第三方遊戲webview
  var thirdPartyGameId = ''.obs; // 第三方遊戲game id
  var thirdPartyGameTpCode = ''.obs; // 第三方遊戲tp code
  var gameTypeIndex = 0.obs; // 遊戲大廳左側遊戲類型index
  var videoToGameRoute = ''.obs; // 影音站跳轉至遊戲頁面路由
  var needsPhoneVerification = false.obs; // 註冊是否前往手機驗證
  var countryCode = Rx<String?>(null); // 註冊手機驗證國碼

  Future<void> fetchData() async {
    GameLobbyApi gameLobbyApi = GameLobbyApi();
    try {
      var result = await gameLobbyApi.getGamePlatformConfig();
      logger.i('game platform config countryCode: ${result.countryCode}');

      switchPaymentPage.value = result.paymentPage!;
      isShowEnvelope.value = result.distributed!;
      gamePageColor.value = result.pageColor!;
      needsPhoneVerification.value = result.needsPhoneVerification!;
      countryCode.value = result.countryCode;
    } catch (e) {
      logger.e('fetchData platform config error: $e');
    }
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
