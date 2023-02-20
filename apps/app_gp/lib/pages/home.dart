import 'package:app_gp/controllers/home_bottom_navigator_controller.dart';
import 'package:app_gp/screens/discover_screen.dart';
import 'package:app_gp/screens/shorts_screen.dart';
import 'package:app_gp/screens/game_screen.dart';
import 'package:app_gp/screens/home_main_screen.dart';
import 'package:app_gp/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// home是一個有bottom navigation bar的頁面
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final homeBottomNavigatorController =
      Get.find<HomeBottomNavigatorController>();

  final screens = const [
    HomeMainScreen(),
    ShortScreen(),
    GameScreen(),
    DiscoverScreen(),
    UserScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => IndexedStack(
              index: homeBottomNavigatorController.currentIndex,
              children: screens,
            )),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => homeBottomNavigatorController.changeIndex(value),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Short',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Game',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
            ),
          ],
        ));
  }
}
