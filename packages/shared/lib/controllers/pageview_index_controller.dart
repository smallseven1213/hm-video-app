import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/screen_control.dart';

class PageViewIndexController extends GetxController {
  RxMap<String, int> pageIndexes = <String, int>{}.obs;
  final RxBool isFullscreen = false.obs;

  void setPageIndex(String pageId, int index) {
    pageIndexes[pageId] = index;
  }

  int getPageIndex(String pageId) {
    return pageIndexes[pageId] ?? 0;
  }

  void toggleFullscreen() {
    isFullscreen.value = !isFullscreen.value;
    if (isFullscreen.value) {
      setScreenLandScape();
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
        SystemUiOverlay.bottom,
      ]);
    }
    update();
  }
}
