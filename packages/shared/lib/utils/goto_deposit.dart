import 'package:flutter/material.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:get/get.dart';

import '../controllers/bottom_navigator_controller.dart';
import '../enums/app_routes.dart';
import '../navigator/delegate.dart';

void gotoDeposit(BuildContext context) async {
  // final gameWalletController = Get.find<GameWalletController>();
  // await gameWalletController.fetchWalletsInitFromThirdLogin();
  final bottomNavigatorController = Get.find<BottomNavigatorController>();
  var everInstance = null;

  if (context.mounted) {
    Navigator.of(context).pop(); //關閉彈窗
    Navigator.of(context).pop(); //關閉modalsheet
    bottomNavigatorController.changeKey('/game');

    // listener for GameWalletController
    final gameWalletController = Get.find<GameWalletController>();
    // listen isLogin value changes
    if (gameWalletController.isLogin.value) {
      MyRouteDelegate.of(context).push(
        GameAppRoutes.depositList,
      );
      if (everInstance != null) {
        everInstance = null;
      }
    }
    everInstance = ever(gameWalletController.isLogin, (bool isLogin) {
      if (isLogin == true) {
        MyRouteDelegate.of(context).push(
          GameAppRoutes.depositList,
        );
        everInstance = null;
      }
    });

    // 等500ms
    // await Future.delayed(Duration(milliseconds: 500));
    // MyRouteDelegate.of(context).push(
    //   GameAppRoutes.depositList,
    // );
  }
  // final gameWalletController = Get.find<GameWalletController>();
  // await gameWalletController.fetchWalletsInitFromThirdLogin();
  // // final bottomNavigatorController = Get.find<BottomNavigatorController>();
  // await MyRouteDelegate.of(context).push(
  //   GameAppRoutes.lobby,
  // );

  // 準備做Logout
}
