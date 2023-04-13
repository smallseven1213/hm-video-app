import 'package:get/get.dart';

import '../controllers/banner_controller.dart';
import '../controllers/bottom_navigator_controller.dart';
import '../controllers/channel_data_controller.dart';
import '../controllers/filter_screen_controller.dart';
import '../controllers/layout_controller.dart';
import '../controllers/list_editor_controller.dart';
import '../controllers/play_record_controller.dart';
import '../controllers/tag_popular_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/user_favorites_actor_controller.dart';
import '../controllers/user_favorites_video_controlle.dart';
import '../controllers/user_video_collection_controller.dart';
import '../controllers/video_popular_controller.dart';

void setupDependencies() {
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<BottonNavigatorController>(() => BottonNavigatorController());

  // Get.lazyPut<LayoutController>(() => LayoutController('1'), tag: 'layout1');
  // Get.lazyPut<LayoutController>(() => LayoutController('2'), tag: 'layout2');
  // Get.lazyPut<LayoutController>(() => LayoutController('3'), tag: 'layout3');
  Get.lazyPut<ChannelDataController>(() => ChannelDataController());
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
  // Get.lazyPut<TagPopularController>(() => TagPopularController());
  /**
   * Get.put(VideoPopularController());
  Get.put(TagPopularController());
   */
  Get.lazyPut<FilterScreenController>(() => FilterScreenController());
}
