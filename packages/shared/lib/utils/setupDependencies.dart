import 'package:get/get.dart';

import '../controllers/banner_controller.dart';
import '../controllers/bottom_navigator_controller.dart';
import '../controllers/channel_data_controller.dart';
import '../controllers/layout_controller.dart';
import '../controllers/list_editor_controller.dart';
import '../controllers/play_record_controller.dart';
import '../controllers/user_controller.dart';

void setupDependencies() {
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<BottonNavigatorController>(() => BottonNavigatorController());

  Get.lazyPut<LayoutController>(() => LayoutController('1'), tag: 'layout1');
  // Get.lazyPut<LayoutController>(() => LayoutController('2'), tag: 'layout2');
  // Get.lazyPut<LayoutController>(() => LayoutController('3'), tag: 'layout3');
  Get.lazyPut<ChannelDataController>(() => ChannelDataController());
  Get.lazyPut<BannerController>(() => BannerController());
  Get.lazyPut<PlayRecordController>(() => PlayRecordController());
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'playrecord');
}
