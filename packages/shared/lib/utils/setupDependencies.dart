import 'package:get/get.dart';

import '../controllers/banner_controller.dart';
import '../controllers/user_controller.dart';

void setupDependencies() {
  // Get.lazyPut(UserController() as InstanceBuilderCallback);
  // Get.lazyPut(BannerController() as InstanceBuilderCallback);
  Get.lazyPut<BannerController>(() => BannerController());
}
