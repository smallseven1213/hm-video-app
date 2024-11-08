import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../apis/image_api.dart';
import '../apis/navigator_api.dart';
import '../enums/navigation_type.dart';
import '../models/navigation.dart';
import '../utils/sid_image_result_decode.dart';

final logger = Logger();

class BottomNavigatorController extends GetxController {
  final activeKey = ''.obs;
  final navigatorItems = <Navigation>[].obs;
  final displayItems = true.obs;
  final fabLink = <Navigation>[].obs;
  final displayFab = true.obs;
  final activeTitle = ''.obs;
  final isVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // set display function
  void setDisplay(bool value) {
    displayItems.value = value;
  }

  // _fetchData
  void fetchData() async {
    var value = await NavigatorApi()
        .getNavigations(NavigationType.bottomNavigator.index);
    var sidImageBox = await Hive.openBox('sidImage');
    for (var item in value) {
      var photoSid = item.photoSid;
      if (photoSid != null) {
        var hasFileInHive = sidImageBox.containsKey(photoSid);
        if (!hasFileInHive) {
          var res = await ImageApi().getSidImageData(photoSid);
          if (res != null) {
            var decoded = getSidImageDecode(res);
            var file = base64Decode(decoded);
            sidImageBox.put(photoSid, file);
          }
        }
      }
    }
    setNavigatorItems(value);
    if (value.isNotEmpty) {
      changeKey(value.first.path!);
    }
  }

  void changeKey(String key) {
    activeKey.value = key;
    var navItem = navigatorItems.firstWhereOrNull((item) => item.path == key);
    if (navItem != null) {
      activeTitle.value = navItem.name ?? '';
    } else {
      activeTitle.value = '';
    }
  }

  void setNavigatorItems(List<Navigation> items) {
    navigatorItems.value = items;
  }

  void fetchFabData(NavigationType navigationType) async {
    var fabData = await NavigatorApi().getNavigations(navigationType.index);
    fabLink.value = fabData;
  }

  void setDisplayFab(bool value) {
    displayFab.value = value;
  }

  // 確認是否為首頁
  bool isHome(String key) {
    return key == navigatorItems.first.path;
  }

  void changeVisible() {
    isVisible.value = !isVisible.value;
  }
}
