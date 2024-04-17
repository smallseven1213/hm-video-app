import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/utils/event_bus.dart';

import '../controllers/bottom_navigator_controller.dart';
import '../navigator/delegate.dart';

final logger = Logger();

BottomNavigatorController bottomNavigatorController =
    Get.find<BottomNavigatorController>();
GamePlatformConfigController gamePlatformConfigController =
    Get.find<GamePlatformConfigController>();

void handleGameUrlMethods(BuildContext context, String url, String routePath) {
  logger.i('game routePath: $routePath');
  logger.i('game url: $url');

  final String? gameId = url.contains('gameId')
      ? Uri.parse(url).queryParameters['gameId'].toString()
      : null;
  final String? tpCode = url.contains('tpCode')
      ? Uri.parse(url).queryParameters['tpCode'].toString()
      : null;
  final String? gameType = url.contains('gameType')
      ? Uri.parse(url).queryParameters['gameType'].toString()
      : null;

  if (routePath == '/home') {
    logger.i('前往遊戲大廳');
  } else if (gameId != '' && tpCode != '' && gameId != null && tpCode != null) {
    gamePlatformConfigController.setThirdPartyGame(true, gameId, tpCode);
  } else if (gameType != null && gameType != '') {
    gamePlatformConfigController.setGameTypeIndex(int.parse(gameType));
    MyRouteDelegate.of(context).push(
      '/home',
      args: {'defaultScreenKey': '/game'},
      removeSamePath: true,
    );
  } else {
    logger.i('else ======>: $url');
    gamePlatformConfigController.setVideoToGameRoute(routePath);
    eventBus.fireEvent("gotoDepositAfterLogin");
  }

  bottomNavigatorController.changeKey('/game');
}
