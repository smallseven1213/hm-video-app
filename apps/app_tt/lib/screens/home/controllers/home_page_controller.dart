import 'package:get/get.dart';

class HomePageController extends GetxController {
  var displayDrawer = false.obs;

  void toggleDrawer() {
    displayDrawer.value = !displayDrawer.value;
  }
}
