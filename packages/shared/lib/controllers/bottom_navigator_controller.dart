import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/navigator_api.dart';
import '../widgets/sid_image.dart';

class BottonNavigatorController extends GetxController {
  final activeIndex = 0.obs;
  final navigatorItems = <BottomNavigationBarItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    NavigatorApi().getNavigations().then((value) {
      var items = value.map((e) {
        return BottomNavigationBarItem(
          icon: e.photoSid == null || e.photoSid == ''
              ? Container()
              : SidImage(
                  sid: e.photoSid!,
                  width: 30,
                  height: 30,
                ),
          label: e.name,
        );
      }).toList();

      setNavigatorItems(items);
    });
  }

  void changeIndex(int index) {
    activeIndex.value = index;
  }

  // replace NavigatorItems
  void setNavigatorItems(List<BottomNavigationBarItem> items) {
    navigatorItems.value = items;
  }
}
