import 'package:game/apis/game_auth_api.dart';
import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

final logger = Logger();

class GameWalletController extends GetxController {
  var wallet = 0.00.obs;
  var isLoading = false.obs;
  var currency = 'TWD'.obs;

  AuthController authController = Get.find<AuthController>();
  GameAuthApi gameAuthApi = GameAuthApi();

  void fetchWalletsInitFromThirdLogin() async {
    if (authController.token.value.isNotEmpty) {
      try {
        final res = await gameAuthApi.login(authController.token.value);
        if (res.code == 200) {
          wallet.value = double.parse(res.data?.balance ?? '0');
          currency.value = res.data?.currency ?? 'TWD';
          logger.i(
              'Game third login success ====> balance:${res.data?.balance}, currency:${res.data?.currency}');
        } else {
          logger.i('Game third login failed: ${res.code}');
        }
      } catch (e) {
        logger.i('Error fetching wallet from third login: $e');
      }
    }

    // ever(authController.token, (token) {
    //   if (token.isNotEmpty) {
    //     gameAuthApi.login(token);
    //   }
    // });
  }

  void fetchWalletsFromPoints() async {
    isLoading.value = true;
    try {
      var res = await GameLobbyApi().getPoints();
      wallet.value = double.parse(res['balance'] ?? '0');
    } catch (error) {
      logger.i('_fetchWallets: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void mutate() {
    fetchWalletsFromPoints();
  }
}
