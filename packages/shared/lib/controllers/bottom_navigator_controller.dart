import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../apis/image_api.dart';
import '../apis/navigator_api.dart';
import '../models/navigation.dart';
import '../utils/sid_image_result_decode.dart';

final logger = Logger();

class BottomNavigatorController extends GetxController {
  final activeKey = ''.obs;
  final navigatorItems = <Navigation>[].obs;
  final displayItems = true.obs;
  final fabLink = <Navigation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchFabData();
  }

  // set display function
  void setDisplay(bool value) {
    displayItems.value = value;
  }

  // _fetchData
  void fetchData() async {
    var value = await NavigatorApi().getNavigations(1);
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
  }

  void setNavigatorItems(List<Navigation> items) {
    navigatorItems.value = items;
  }

  fetchFabData() async {
    var fabData = await NavigatorApi().getNavigations(4);
    fabLink.value = fabData;
  }
}
