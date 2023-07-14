import 'package:get/get.dart';
import 'package:shared/controllers/user_navigator_controller.dart';
import '../controllers/actor_region_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/banner_controller.dart';
import '../controllers/bottom_navigator_controller.dart';
import '../controllers/filter_screen_controller.dart';
import '../controllers/list_editor_controller.dart';
import '../controllers/pageview_index_controller.dart';
import '../controllers/play_record_controller.dart';
import '../controllers/response_controller.dart';
import '../controllers/search_page_data_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/user_favorites_actor_controller.dart';
import '../controllers/user_favorites_short_controlle.dart';
import '../controllers/user_favorites_supplier_controller.dart';
import '../controllers/user_favorites_video_controlle.dart';
import '../controllers/user_search_history_controller.dart';
import '../controllers/user_short_collection_controller.dart';
import '../controllers/user_video_collection_controller.dart';
import '../controllers/video_ads_controller.dart';

void setupDependencies() {
  Get.lazyPut<AuthController>(() => AuthController());
  Get.lazyPut<ApiResponseErrorCatchController>(
      () => ApiResponseErrorCatchController());
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<UserNavigatorController>(() => UserNavigatorController());
  Get.lazyPut<BottonNavigatorController>(() => BottonNavigatorController());
  Get.lazyPut<BannerController>(() => BannerController());
  Get.lazyPut<PlayRecordController>(() => PlayRecordController(tag: 'vod'),
      tag: 'vod');
  Get.lazyPut<PlayRecordController>(() => PlayRecordController(tag: 'short'),
      tag: 'short');
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'playrecord');
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'collection');
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'favorites');
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: 'notifications');
  Get.lazyPut<UserFavoritesSupplierController>(
      () => UserFavoritesSupplierController());
  Get.lazyPut<UserFavoritesActorController>(
      () => UserFavoritesActorController());
  Get.lazyPut<UserFavoritesVideoController>(
      () => UserFavoritesVideoController());
  Get.lazyPut<UserFavoritesShortController>(
      () => UserFavoritesShortController());
  Get.lazyPut<UserVodCollectionController>(() => UserVodCollectionController());
  Get.lazyPut<UserShortCollectionController>(
      () => UserShortCollectionController());
  Get.lazyPut<FilterScreenController>(() => FilterScreenController());
  Get.lazyPut<ActorRegionController>(() => ActorRegionController());
  Get.lazyPut<VideoAdsController>(() => VideoAdsController());
  // lazyPut UserSearchHistoryController
  Get.lazyPut<UserSearchHistoryController>(() => UserSearchHistoryController());
  Get.lazyPut<PageViewIndexController>(() => PageViewIndexController());
  Get.lazyPut<SearchPageDataController>(() => SearchPageDataController());
}
