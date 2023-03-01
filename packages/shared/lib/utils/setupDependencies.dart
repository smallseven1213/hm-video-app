import 'package:get/get.dart';

import '../controllers/banner_controller.dart';
import '../controllers/bottom_navigator_controller.dart';
import '../controllers/layout_controller.dart';
import '../controllers/user_controller.dart';

void setupDependencies() {
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<BottonNavigatorController>(() => BottonNavigatorController());

  Get.lazyPut<LayoutController>(() => LayoutController('1'), tag: 'layout1');
  Get.lazyPut<LayoutController>(() => LayoutController('2'), tag: 'layout2');
  Get.lazyPut<LayoutController>(() => LayoutController('3'), tag: 'layout3');
  Get.lazyPut<BannerController>(() => BannerController());
}
