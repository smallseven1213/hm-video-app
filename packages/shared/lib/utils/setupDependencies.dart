import 'package:get/get.dart';

import '../controllers/user_controller.dart';

void setupDependencies() {
  Get.lazyPut(UserController() as InstanceBuilderCallback);
}
