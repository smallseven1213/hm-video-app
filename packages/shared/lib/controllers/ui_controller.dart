import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class UIController extends GetxController {
  // final int layoutId;
  final RxBool isFullscreen = false.obs;
  var displayChannelTab = true.obs;
  var displayHomeNavigationBar = true.obs;
  var isShortVideoMute = kIsWeb ? true.obs : false.obs;

  UIController();

  void setDisplay(bool value) {
    displayChannelTab.value = value;
    displayHomeNavigationBar.value = value;
  }

  void toggleShortVideoMute() {
    isShortVideoMute.value = !isShortVideoMute.value;
  }
}
