import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottonNavigatorController extends GetxController {
  final activeIndex = 0.obs;
  final navigatorItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, color: Colors.white),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search, color: Colors.white),
      label: 'Short',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, color: Colors.white),
      label: 'Game',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, color: Colors.white),
      label: 'Discover',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, color: Colors.white),
      label: 'User',
    ),
  ].obs;

  void changeIndex(int index) {
    activeIndex.value = index;
  }

  // replace NavigatorItems
  void setNavigatorItems(List<BottomNavigationBarItem> items) {
    navigatorItems.value = items;
  }
}
