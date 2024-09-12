import 'package:game/apis/game_api.dart';
import 'package:game/apis/game_auth_api.dart';
import 'package:game/services/game_system_config.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

final logger = Logger();

class GameWalletController extends GetxController {
  var wallet = 0.00.obs;
  var isLoading = false.obs;
  var currency = 'TWD'.obs;
  var apiHost = ''.obs;
  var token = ''.obs;

  AuthController authController = Get.find<AuthController>();
  GameAuthApi gameAuthApi = GameAuthApi();
  GameSystemConfig gameSystemConfig = GameSystemConfig();

  Future<void> fetchWalletsInitFromThirdLogin() async {
    if (authController.token.value.isNotEmpty) {
      try {
        final res = await gameAuthApi.login(authController.token.value);
        if (res.code == 200) {
          wallet.value = double.parse(res.data?.balance ?? '0');
          currency.value = res.data?.currency ?? 'TWD';
          apiHost.value = res.data?.apiHost ?? '';
          token.value = res.data?.token ?? '';

          gameSystemConfig.setApiHost(res.data!.apiHost);

          logger.i(
              'Game third login success ====> balance:${res.data?.balance}, currency:${res.data?.currency}');
        } else {
          logger.i('Game third login failed: ${res.code}');
        }
      } catch (e) {
        logger.i('Error fetching wallet from third login: $e');
      }
    }
  }

  void fetchWalletsFromPoints() async {
    isLoading.value = true;
    try {
      var res = await GameLobbyApi().getPoints();
      wallet.value = double.parse(res['balance'].toString());
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
