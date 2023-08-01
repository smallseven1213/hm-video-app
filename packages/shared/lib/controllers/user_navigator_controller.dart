import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/image_api.dart';
import 'package:shared/utils/sid_image_result_decode.dart';

import '../apis/navigator_api.dart';
import '../models/navigation.dart';

final logger = Logger();

class UserNavigatorController extends GetxController {
  final activeKey = ''.obs;
  final quickLink = <Navigation>[].obs;
  final moreLink = <Navigation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchQuickLinkData();
  }

  fetchData() async {
    var moreLinkData = await NavigatorApi().getNavigations(3);
    moreLink.value = moreLinkData;
    saveImage(moreLinkData);
  }

  fetchQuickLinkData() async {
    var quickLinkData = await NavigatorApi().getNavigations(2);
    quickLink.value = quickLinkData;
    saveImage(quickLinkData);
  }

  void saveImage(List<Navigation> value) async {
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
  }
}
