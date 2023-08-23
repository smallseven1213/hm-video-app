import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../utils/screen_control.dart';

var logger = Logger();

class UIController extends GetxController {
  // final int layoutId;
  final RxBool isFullscreen = false.obs;
  var displayChannelTab = true.obs;
  var displayHomeNavigationBar = true.obs;

  UIController();

  // set display function
  void setDisplay(bool value) {
    displayChannelTab.value = value;
    displayHomeNavigationBar.value = value;
  }
}
