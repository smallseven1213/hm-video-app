library app_routes;

import 'package:flutter/material.dart';
import 'package:app_gs/pages/actor.dart' deferred as actor_page;
import 'package:app_gs/pages/configs.dart' deferred as configs_page;
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/page_loader.dart';

import '../pages/actors.dart' deferred as actors_page;
import '../pages/collection.dart' deferred as collection_page;
import '../pages/home.dart' deferred as home_page;
import '../pages/id.dart' deferred as id_page;
import '../pages/login.dart' deferred as login_page;
import '../pages/playrecord.dart' deferred as playrecord_page;
import '../pages/register.dart' deferred as register_page;
import '../pages/nickname.dart' deferred as nickname_page;
import '../pages/share.dart' deferred as share_page;
import '../pages/sharerecord.dart' deferred as sharerecord_page;
import '../pages/shorts_by_block.dart' deferred as shorts_by_block_page;
import '../pages/shorts_by_local.dart' deferred as shorts_by_local_page;
import '../pages/shorts_by_channel.dart' deferred as shorts_by_channel_page;
import '../pages/shorts_by_supplier.dart' deferred as shorts_by_supplier_page;
import '../pages/shorts_by_tag.dart' deferred as shorts_by_tag_page;
import '../pages/supplier.dart' deferred as supplier_page;
import '../pages/supplier_tag_video.dart' deferred as supplier_tag_video_page;
import '../pages/tag_video.dart' deferred as tag_video_page;
import '../pages/publisher.dart' deferred as publisher_page;
import '../pages/update_password.dart' deferred as update_password_page;
import '../pages/video_by_block.dart' deferred as video_by_block_page;
import '../pages/favorites.dart' deferred as favorites_page;
import '../pages/filter.dart' deferred as filter_page;
import '../pages/notifications.dart' deferred as notifications_page;
import '../pages/search.dart' deferred as search_page;
import '../pages/video.dart' deferred as video_page;
import '../screens/apps_screen/index.dart' deferred as apps_screen;
import '../screens/demo.dart' deferred as demo_screen;
import '../pages/suppliers.dart' deferred as suppliers_screen;
import '../widgets/page_loader.dart';
// import '../screens/video_demo.dart' deferred as video_demo_screen;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.demo: (context, args) => PageLoader(
        loadLibrary: demo_screen.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => demo_screen.Demo(),
      ),
  AppRoutes.home: (context, args) => PageLoader(
        loadLibrary: home_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => home_page.HomePage(
          defaultScreenKey: args['defaultScreenKey'] as String?,
        ),
      ),
  AppRoutes.video: (context, args) => PageLoader(
        loadLibrary: video_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => video_page.Video(args: args),
      ),
  AppRoutes.videoByBlock: (context, args) => PageLoader(
        loadLibrary: video_by_block_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => video_by_block_page.VideoByBlockPage(
          blockId: args['blockId'] as int,
          title: args['title'] as String,
          channelId: args['channelId'] as int,
          film: args['film'] == null ? 1 : args['film'] as int,
        ),
      ),
  AppRoutes.publisher: (context, args) => PageLoader(
        loadLibrary: publisher_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => publisher_page.PublisherPage(
          id: args['id'] as int,
        ),
      ),
  AppRoutes.tag: (context, args) => PageLoader(
        loadLibrary: tag_video_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => tag_video_page.TagVideoPage(
          key: ValueKey('tag-video-${args['id']}'),
          id: args['id'] as int,
          title: args['title'] as String,
        ),
      ),
  AppRoutes.actor: (context, args) => PageLoader(
        loadLibrary: actor_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => actor_page.ActorPage(
          id: args['id'] as int,
        ),
      ),
  AppRoutes.login: (context, args) => PageLoader(
        loadLibrary: login_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => login_page.LoginPage(),
      ),
  AppRoutes.nickname: (context, args) => PageLoader(
        loadLibrary: nickname_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => nickname_page.NicknamePage(),
      ),
  AppRoutes.register: (context, args) => PageLoader(
        loadLibrary: register_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => register_page.RegisterPage(),
      ),
  AppRoutes.share: (context, args) => PageLoader(
        loadLibrary: share_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => share_page.SharePage(),
      ),
  AppRoutes.playRecord: (context, args) => PageLoader(
        loadLibrary: playrecord_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => playrecord_page.PlayRecordPage(),
      ),
  AppRoutes.shareRecord: (context, args) => PageLoader(
        loadLibrary: sharerecord_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => sharerecord_page.ShareRecord(),
      ),
  AppRoutes.apps: (context, args) => PageLoader(
        loadLibrary: apps_screen.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => apps_screen.AppsScreen(),
      ),
  AppRoutes.favorites: (context, args) => PageLoader(
        loadLibrary: favorites_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => favorites_page.FavoritesPage(),
      ),
  AppRoutes.collection: (context, args) => PageLoader(
        loadLibrary: collection_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => collection_page.CollectionPage(),
      ),
  AppRoutes.notifications: (context, args) => PageLoader(
        loadLibrary: notifications_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => notifications_page.NotificationsPage(),
      ),
  AppRoutes.search: (context, args) => PageLoader(
        loadLibrary: search_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => search_page.SearchPage(
          inputDefaultValue: args['inputDefaultValue'] as String,
          autoSearch: args['autoSearch'] as bool,
        ),
      ),
  AppRoutes.filter: (context, args) => PageLoader(
        loadLibrary: filter_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => filter_page.FilterPage(),
      ),
  AppRoutes.actors: (context, args) => PageLoader(
        loadLibrary: actors_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => actors_page.ActorsPage(),
      ),
  AppRoutes.supplier: (context, args) => PageLoader(
        loadLibrary: supplier_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => supplier_page.SupplierPage(
          id: args['id'] as int,
        ),
      ),
  AppRoutes.supplierTag: (context, args) => PageLoader(
        loadLibrary: supplier_tag_video_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => supplier_tag_video_page.SupplierTagVideoPage(
          tagId: args['tagId'] as int,
          tagName: args['tagName'],
        ),
      ),
  AppRoutes.shortsByTag: (context, args) => PageLoader(
        loadLibrary: shorts_by_tag_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => shorts_by_tag_page.ShortsByTagPage(
          uuid: args['uuid'] as String,
          videoId: args['videoId'] as int,
          tagId: args['tagId'] as int,
        ),
      ),
  AppRoutes.shortsBySupplier: (context, args) => PageLoader(
        loadLibrary: shorts_by_supplier_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => shorts_by_supplier_page.ShortsBySupplierPage(
          uuid: args['uuid'] as String,
          videoId: args['videoId'] as int,
          supplierId: args['supplierId'] as int,
        ),
      ),
  AppRoutes.shortsByBlock: (context, args) => PageLoader(
        loadLibrary: shorts_by_block_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => shorts_by_block_page.ShortsByBlockPage(
          uuid: args['uuid'] as String,
          videoId: args['videoId'] as int,
          areaId: args['areaId'] as int,
        ),
      ),
  AppRoutes.shortsByLocal: (context, args) => PageLoader(
        loadLibrary: shorts_by_local_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => shorts_by_local_page.ShortsByLocalPage(
          uuid: args['uuid'] as String,
          videoId: args['videoId'] as int,
          itemId: args['itemId'] as int,
        ),
      ),
  AppRoutes.shortsByChannel: (context, args) => PageLoader(
        loadLibrary: shorts_by_channel_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => shorts_by_channel_page.ShortsByChannelPage(
          uuid: args['uuid'] as String,
          videoId: args['videoId'] as int,
          supplierId: args['supplierId'] as int,
        ),
      ),
  AppRoutes.configs: (context, args) => PageLoader(
        loadLibrary: configs_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => configs_page.ConfigsPage(),
      ),
  AppRoutes.updatePassword: (context, args) => PageLoader(
        loadLibrary: update_password_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => update_password_page.UpdatePasswordPage(),
      ),
  AppRoutes.idCard: (context, args) => PageLoader(
        loadLibrary: id_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => id_page.IDCardPage(),
      ),
  // suppliers to suppliers_screen
  AppRoutes.suppliers: (context, args) => PageLoader(
        loadLibrary: suppliers_screen.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => suppliers_screen.SuppliersPage(),
      ),
};
