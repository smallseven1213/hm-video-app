import 'package:game/controllers/game_param_config_controller.dart';
import 'package:get/get.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/controllers/game_auth_controller.dart';
import 'package:game/controllers/game_response_controller.dart';
import 'package:shared/controllers/user_controller.dart';

void setupGameDependencies() {
  Get.lazyPut<GameAuthController>(() => GameAuthController());
  Get.lazyPut<GameApiResponseErrorCatchController>(
      () => GameApiResponseErrorCatchController());
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<GameBannerController>(() => GameBannerController());
  Get.lazyPut<GamesListController>(() => GamesListController());
  Get.lazyPut<GameWalletController>(() => GameWalletController());
  Get.lazyPut<GameWithdrawController>(() => GameWithdrawController());
  Get.lazyPut<GameParamConfigController>(() => GameParamConfigController());
}
