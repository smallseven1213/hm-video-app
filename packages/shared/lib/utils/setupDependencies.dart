import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/banner_controller.dart';
import '../controllers/bottom_navigator_controller.dart';
import '../controllers/channel_data_controller.dart';
import '../controllers/filter_screen_controller.dart';
import '../controllers/layout_controller.dart';
import '../controllers/list_editor_controller.dart';
import '../controllers/play_record_controller.dart';
import '../controllers/response_controller.dart';
import '../controllers/tag_popular_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/user_favorites_actor_controller.dart';
import '../controllers/user_favorites_video_controlle.dart';
import '../controllers/user_video_collection_controller.dart';
import '../controllers/video_popular_controller.dart';

void setupDependencies() {
  Get.lazyPut<AuthController>(() => AuthController());
  Get.lazyPut<ResponseController>(() => ResponseController());
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<BottonNavigatorController>(() => BottonNavigatorController());
  Get.lazyPut<BannerController>(() => BannerController());
  Get.lazyPut<PlayRecordController>(() => PlayRecordController());
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'playrecord');
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'user_video_collection');
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'favorites');
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'notifications');
  Get.lazyPut<UserFavoritesActorController>(
      () => UserFavoritesActorController());
  Get.lazyPut<UserFavoritesVideoController>(
      () => UserFavoritesVideoController());
  Get.lazyPut<UserCollectionController>(() => UserCollectionController());
  Get.lazyPut<FilterScreenController>(() => FilterScreenController());
}
