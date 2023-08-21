import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

var logger = Logger();

class UIController extends GetxController {
  // final int layoutId;
  var displayChannelTab = true.obs;
  var displayHomeNavigationBar = true.obs;

  UIController();

  // set display function
  void setDisplay(bool value) {
    displayChannelTab.value = value;
    displayHomeNavigationBar.value = value;
  }
}
