import 'package:get/get.dart';

class RouteController extends GetxController {
  var currentPage = ''.obs;
  var isPushed = false.obs;

  void onPush(String routeName) {
    currentPage.value = routeName;
    isPushed.value = true;
  }

  void onPop() {
    isPushed.value = false;
  }
}
