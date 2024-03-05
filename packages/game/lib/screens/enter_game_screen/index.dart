import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/game_auth_api.dart';
import 'package:game/screens/lobby.dart';

import 'package:shared/controllers/auth_controller.dart';
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
  AuthController authController = Get.find<AuthController>();
  GameAuthApi gameAuthApi = GameAuthApi();

  @override
  void initState() {
    super.initState();
    gameConfigController.fetchData();

    if (authController.token.value.isNotEmpty) {
      gameAuthApi.login(authController.token.value);
    }

    ever(authController.token, (token) {
      if (token.isNotEmpty) {
        gameAuthApi.login(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => gameConfigController.gamePageColor.value != 0
        ? const GameLobby()
        : const CircularProgressIndicator());
  }
}
