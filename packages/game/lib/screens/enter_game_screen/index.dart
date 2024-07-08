import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/controllers/game_param_config_controller.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/screens/lobby.dart';
import 'package:game/utils/loading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';

final logger = Logger();

class EnterGame extends StatefulWidget {
  const EnterGame({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterGame> createState() => _EnterGame();
}

class _EnterGame extends State<EnterGame> {
  GameWalletController gameWalletController = Get.find<GameWalletController>();
  GamePlatformConfigController gamePlatformConfigController =
      Get.find<GamePlatformConfigController>();
  GamesListController gamesListController = Get.find<GamesListController>();

  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();
  GameBannerController gameBannerController = Get.find<GameBannerController>();
  GameParamConfigController gameParamConfigController =
      Get.find<GameParamConfigController>();

  bool canEnter = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAPICalls();
    });
  }

  Future<void> _initAPICalls() async {
    try {
      // 依序打三個 API
      await gameWalletController.fetchWalletsInitFromThirdLogin();
      await gamePlatformConfigController.fetchData();
      await gamesListController.fetchGames();
      // 當這三個 API 完成後，並行打其他三個 API
      await Future.wait([
        gameConfigController.fetchData(),
        gameBannerController.fetchGameBanners(),
        gameParamConfigController.fetchData(),
      ]);

      logger.i('所有 API 請求完成');
      setState(() {
        canEnter = true;
      });
    } catch (e) {
      logger.e('API 請求失敗: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (gameConfigController.gamePageColor.value == 0) {
        return Center(child: GameLoading());
      } else {
        return GameLobby();
      }
    });
  }
}
