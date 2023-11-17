import 'package:get/get.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/controllers/user_navigator_controller.dart';
import '../controllers/actor_region_controller.dart';
import '../controllers/apps_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/banner_controller.dart';
import '../controllers/bottom_navigator_controller.dart';
import '../controllers/event_controller.dart';
import '../controllers/filter_screen_controller.dart';
import '../controllers/filter_short_screen_controller.dart';
import '../controllers/filter_temp_controller.dart';
import '../controllers/filter_video_screen_controller.dart';
import '../controllers/list_editor_controller.dart';
import '../controllers/pageview_index_controller.dart';
import '../controllers/play_record_controller.dart';
import '../controllers/redemption_controller.dart';
import '../controllers/response_controller.dart';
import '../controllers/route_controller.dart';
import '../controllers/search_page_data_controller.dart';
import '../controllers/search_temp_controller.dart';
import '../controllers/ui_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/user_promo_controller.dart';
import '../controllers/user_favorites_actor_controller.dart';
import '../controllers/user_favorites_short_controlle.dart';
import '../controllers/user_favorites_supplier_controller.dart';
import '../controllers/user_favorites_video_controlle.dart';
import '../controllers/user_search_history_controller.dart';
import '../controllers/user_short_collection_controller.dart';
import '../controllers/user_video_collection_controller.dart';
import '../controllers/video_ads_controller.dart';
import '../enums/list_editor_category.dart';
import '../enums/play_record_type.dart';

void setupDependencies() async {
  Get.put(RouteController());
  Get.lazyPut<SystemConfigController>(() => SystemConfigController());
  Get.putAsync<SystemConfigController>(() async {
    await Future.delayed(const Duration(seconds: 1));

    return SystemConfigController();
  });
  Get.lazyPut<AuthController>(() => AuthController());
  Get.lazyPut<ApiResponseErrorCatchController>(
      () => ApiResponseErrorCatchController());
  Get.lazyPut<AppsController>(() => AppsController());
  Get.lazyPut<UserController>(() => UserController());
  Get.lazyPut<UserPromoController>(() => UserPromoController());
  Get.lazyPut<UserNavigatorController>(() => UserNavigatorController());
  Get.lazyPut<BottomNavigatorController>(() => BottomNavigatorController());
  Get.lazyPut<BannerController>(() => BannerController());
  Get.lazyPut<PlayRecordController>(
      () => PlayRecordController(tag: PlayRecordType.video.toString()),
      tag: PlayRecordType.video.toString());
  Get.lazyPut<PlayRecordController>(
      () => PlayRecordController(tag: PlayRecordType.short.toString()),
      tag: PlayRecordType.short.toString());
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: ListEditorCategory.playrecord.toString());
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: ListEditorCategory.collection.toString());
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: ListEditorCategory.favorites.toString());
  Get.lazyPut<ListEditorController>(() => ListEditorController(),
      tag: ListEditorCategory.notifications.toString());
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
  Get.lazyPut<FilterVideoScreenController>(() => FilterVideoScreenController());
  Get.lazyPut<FilterShortScreenController>(() => FilterShortScreenController());
  Get.lazyPut<FilterTempShortController>(() => FilterTempShortController());
  Get.lazyPut<ActorRegionController>(() => ActorRegionController());
  Get.lazyPut<VideoAdsController>(() => VideoAdsController());
  // lazyPut UserSearchHistoryController
  Get.lazyPut<UIController>(() => UIController());
  Get.lazyPut<UserSearchHistoryController>(() => UserSearchHistoryController());
  Get.lazyPut<PageViewIndexController>(() => PageViewIndexController());
  Get.lazyPut<SearchPageDataController>(() => SearchPageDataController());
  Get.lazyPut<SearchTempShortController>(() => SearchTempShortController());
  Get.lazyPut<RedemptionController>(() => RedemptionController());
  Get.lazyPut<EventController>(() => EventController());
}
