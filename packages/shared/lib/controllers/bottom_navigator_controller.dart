import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottonNavigatorController extends GetxController {
  final activeIndex = 0.obs;
  final navigatorItems = [
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
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeIndex(int index) {
    activeIndex.value = index;
  }

  // replace NavigatorItems
  void setNavigatorItems(List<BottomNavigationBarItem> items) {
    navigatorItems.value = items;
  }
}
