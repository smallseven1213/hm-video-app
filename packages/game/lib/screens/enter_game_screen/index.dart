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
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();
  GameWalletController gameWalletController = Get.find<GameWalletController>();
  GamesListController gamesListController = Get.find<GamesListController>();
  GameBannerController gameBannerController = Get.find<GameBannerController>();
  GameParamConfigController gameParamConfigController =
      Get.find<GameParamConfigController>();

  @override
  void initState() {
    super.initState();
    fetchThirdLogin();
  }

  Future<void> fetchThirdLogin() async {
    try {
      gameWalletController.fetchWalletsInitFromThirdLogin().then((_) {
        gameConfigController.fetchData().then((_) {
          _initGameData();
        });
      });
    } catch (e) {
      logger.e("Error initializing data: $e");
    }
  }

  Future<void> _initGameData() async {
    try {
      await GameLobbyApi().registerGame();
      // await gamesListController.fetchGames();
      await gameBannerController.fetchGameBanners();
      await gameParamConfigController.fetchData();
    } catch (e) {
      logger.e("Error initializing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => gameConfigController.gamePageColor.value != 0
        ? const GameLobby()
        : const Center(child: GameLoading()));
  }
}
