import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

final logger = Logger();

class GamePlatformConfigController extends GetxController {
  var switchPaymentPage = 0.obs; // 存款頁面切換
  var gamePageColor = 0.obs; // 遊戲大廳theme
  var isShowEnvelope = false.obs; // 遊戲大廳是否顯示紅包
  var isOpenThirdPartyGame = false.obs; // 是否開啟第三方遊戲webview
  var thirdPartyGameId = ''.obs; // 第三方遊戲game id
  var thirdPartyGameTpCode = ''.obs; // 第三方遊戲tp code
  var videoToGameRoute = ''.obs; // 影音站跳轉至遊戲頁面路由
  var needsPhoneVerification = false.obs; // 註冊是否前往手機驗證
  var countryCode = Rx<String?>(null); // 註冊手機驗證國碼
  var isGameLobbyBalanceShow = true.obs; // 是否顯示遊戲大廳餘額
  var depositRoute = '/game/deposit_page_polling'.obs; // 存款頁面路由

  GameWalletController gameWalletController = Get.find<GameWalletController>();
  AuthController authController = Get.find<AuthController>();

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
      isGameLobbyBalanceShow.value = result.isGameLobbyBalanceShow!;

      depositRoute.value =
          switchPaymentPageTypeMapper[switchPaymentPage.value] ??
              GameAppRoutes.depositPolling;
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

  void setSwitchPaymentPage(int type) {
    switchPaymentPage.value = type;
  }

  void setVideoToGameRoute(String route) {
    videoToGameRoute.value = route;
  }
}

Map<int, String> switchPaymentPageTypeMapper = {
  1: GameAppRoutes.depositPolling,
  2: GameAppRoutes.depositList,
  3: GameAppRoutes.depositBankMobile,
};
