import 'package:app_gp/config/colors.dart';
import 'package:app_gp/screens/discover_screen.dart';
import 'package:app_gp/screens/shorts_screen.dart';
import 'package:app_gp/screens/game_screen.dart';
import 'package:app_gp/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/models/color_keys.dart';

import '../screens/main_screen/index.dart';

// home是一個有bottom navigation bar的頁面
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final bottomNavigatorController = Get.find<BottonNavigatorController>();

  final screens = [
    HomeMainScreen(),
    ShortScreen(),
    GameScreen(),
    DiscoverScreen(),
    UserScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        body: IndexedStack(
          index: bottomNavigatorController.activeIndex.value,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.colors[ColorKeys.background],
          onTap: (value) => bottomNavigatorController.changeIndex(value),
          items: bottomNavigatorController.navigatorItems,
        )));
    // return Scaffold(
    //     body: Obx(() => IndexedStack(
    //           index: bottomNavigatorController.activeIndex.value,
    //           children: screens,
    //         )),
    //     bottomNavigationBar: Obx(() => BottomNavigationBar(
    //           backgroundColor: AppColors.colors[ColorKeys.background],
    //           onTap: (value) => bottomNavigatorController.changeIndex(value),
    //           items: bottomNavigatorController.navigatorItems,
    //         )));
  }
}
